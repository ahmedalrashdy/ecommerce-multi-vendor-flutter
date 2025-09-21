import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/paginated_state.dart';
import '../../../core/repos/cart_repo.dart';
import '../models/cart_item_model.dart';
import '../models/grouped_cart_by_store_model.dart';

class CartState extends PaginationState<GroupedCartByStoreModel> {
  final int? selectedStoreCartId;
  const CartState({
    super.hasReachedEnd,
    super.items,
    super.nextCursor,
    this.selectedStoreCartId,
  });
  @override
  CartState copyWith({
    List<GroupedCartByStoreModel>? items,
    String? nextCursor,
    bool? hasReachedEnd,
    bool setNextCursorToNull = false,
    int? selectedStoreCartId,
    bool setSelectedStoreCartIdToNell = false,
  }) {
    return CartState(
      items: items ?? this.items,
      nextCursor: setNextCursorToNull ? null : (nextCursor ?? this.nextCursor),
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      selectedStoreCartId: setSelectedStoreCartIdToNell
          ? null
          : (selectedStoreCartId ?? this.selectedStoreCartId),
    );
  }

  @override
  List<Object?> get props => [...super.props, selectedStoreCartId];
}

class CartNotifier extends AsyncNotifier<CartState> {
  @override
  Future<CartState> build() async {
    final response = await ref.read(cartRepoProvider).getCartItems();
    return CartState(
      items: response.results,
      nextCursor: response.next,
      hasReachedEnd: response.next == null,
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.hasReachedEnd || state.isLoading)
      return;

    state = AsyncLoading<CartState>().copyWithPrevious(state);

    try {
      final response = await ref
          .read(cartRepoProvider)
          .getCartItems(url: currentState.nextCursor);

      state = AsyncData(currentState.copyWith(
        items: [...currentState.items, ...response.results],
        nextCursor: response.next,
        hasReachedEnd: response.next == null,
      ));
    } catch (e, st) {
      state = AsyncError<CartState>(e, st).copyWithPrevious(state);
    }
  }

  void selectStoreCart(int storeCartId) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(selectedStoreCartId: storeCartId));
  }

  Future<void> updateQuantity(
      int storeId, int cartItemId, int newQuantity) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final originalItems = currentState.items;
    late CartItemModel originalItem;

    final newItems = originalItems.map((storeCart) {
      if (storeCart.id == storeId) {
        return storeCart.copyWith(
          items: storeCart.items.map((cartItem) {
            if (cartItem.id == cartItemId) {
              originalItem = cartItem; // احتفظ بالنسخة الأصلية
              return cartItem.copyWith(quantity: newQuantity, isUpdating: true);
            }
            return cartItem;
          }).toList(),
        );
      }
      return storeCart;
    }).toList();

    state = AsyncData(currentState.copyWith(items: newItems));

    try {
      final updatedItemFromServer = await ref
          .read(cartRepoProvider)
          .updateItemQuantity(cartItemId: cartItemId, newQuantity: newQuantity);

      final finalStores = state.value!.items.map((storeCart) {
        if (storeCart.id == updatedItemFromServer.storeId) {
          return storeCart.copyWith(
            items: storeCart.items
                .map((item) => item.id == updatedItemFromServer.id
                    ? updatedItemFromServer
                    : item)
                .toList(),
          );
        }
        return storeCart;
      }).toList();

      state = AsyncData(state.value!.copyWith(items: finalStores));
    } catch (e) {
      // ✅ منطق تراجع أكثر وضوحًا
      final revertedStores = state.value!.items.map((storeCart) {
        if (storeCart.id == storeId) {
          return storeCart.copyWith(
            items: storeCart.items.map((item) {
              return item.id == cartItemId
                  ? originalItem.copyWith(isUpdating: false)
                  : item;
            }).toList(),
          );
        }
        return storeCart;
      }).toList();
      state = AsyncData(state.value!.copyWith(items: revertedStores));
    }
  }

  Future<void> addItem({
    required int variantId,
    required int quantity,
  }) async {
    final repo = ref.read(cartRepoProvider);
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final existingItem = _findItemByVariantId(
        currentState.items.expand((e) => e.items).toList(), variantId);
    if (existingItem != null) {
      final newQuantity = existingItem.quantity + quantity;
      await updateQuantity(existingItem.storeId, existingItem.id, newQuantity);
      return;
    }

    state = AsyncLoading<CartState>().copyWithPrevious(state);

    try {
      final newItemFromServer = await repo.addItemToCart(
        variantId: variantId,
        quantity: quantity,
      );

      // إضافة العنصر ضمن المتجر المناسب أو إنشاء متجر جديد إذا لم يكن موجود
      final updatedItems =
          List<GroupedCartByStoreModel>.from(currentState.items);
      final storeIndex =
          updatedItems.indexWhere((s) => s.id == newItemFromServer.storeId);
      if (storeIndex != -1) {
        final store = updatedItems[storeIndex];
        updatedItems[storeIndex] =
            store.copyWith(items: [...store.items, newItemFromServer]);
      } else {
        updatedItems.add(GroupedCartByStoreModel(
          id: newItemFromServer.storeId,
          name: newItemFromServer.storeName,
          logo: null,
          coverImage: null,
          storeSubTotal: newItemFromServer.price * newItemFromServer.quantity,
          items: [newItemFromServer],
        ));
      }

      state = AsyncData(currentState.copyWith(items: updatedItems));
    } catch (e, st) {
      state = AsyncError<CartState>(e, st).copyWithPrevious(state);
    }
  }

  double storeCartTotal(GroupedCartByStoreModel store) {
    final items = store.items.every((item) => !item.isSelected)
        ? store.items
        : store.items.where((item) => item.isSelected);
    return items.fold(0.0, (value, item) => value + item.price * item.quantity);
  }

  void toggleSelectCartItem(int storeId, int cartItemId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    final storesItems = currentState.items.map((storeCart) {
      if (storeCart.id == storeId) {
        return storeCart.copyWith(
          items: storeCart.items.map((item) {
            if (item.id == cartItemId) {
              return item.copyWith(isSelected: !item.isSelected);
            }
            return item;
          }).toList(),
        );
      }
      return storeCart;
    }).toList();
    state = AsyncData(currentState.copyWith(items: storesItems));
  }

  Future<void> deleteItem(int storeId, int cartItemId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final originalItems = currentState.items;
    late CartItemModel itemToDelete;

    final itemsWithLoading = originalItems.map((storeCart) {
      if (storeCart.id == storeId) {
        return storeCart.copyWith(
          items: storeCart.items.map((item) {
            if (item.id == cartItemId) {
              itemToDelete = item;
              return item.copyWith(isUpdating: true);
            }
            return item;
          }).toList(),
        );
      }
      return storeCart;
    }).toList();

    state = AsyncData(currentState.copyWith(items: itemsWithLoading));

    try {
      await ref.read(cartRepoProvider).deleteCartItem(cartItemId: cartItemId);

      final finalItems = state.value!.items
          .map((storeCart) {
            final filteredItems =
                storeCart.items.where((item) => item.id != cartItemId).toList();
            return storeCart.copyWith(items: filteredItems);
          })
          .where((storeCart) => storeCart.items.isNotEmpty)
          .toList();

      state = AsyncData(state.value!.copyWith(items: finalItems));
    } catch (e) {
      // ✅ التراجع عن طريق إرجاع القائمة الأصلية بالكامل
      state = AsyncData(currentState.copyWith(items: originalItems));
    }
  }

  CartItemModel? _findItemByVariantId(
      List<CartItemModel> items, int variantId) {
    try {
      return items.firstWhere((item) => item.variantId == variantId);
    } catch (e) {
      return null;
    }
  }
}

final cartNotifierProvider = AsyncNotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});
