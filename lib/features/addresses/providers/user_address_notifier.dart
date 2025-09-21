import 'package:collection/collection.dart';
import 'package:ecommerce/core/helpers/app_message.dart';
import 'package:ecommerce/core/helpers/handle_exception.dart';
import 'package:ecommerce/core/models/user_address_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/paginated_state.dart';
import '../../../core/repos/address_repo.dart';

class UserAddressPaginatedState extends PaginationState<UserAddressModel> {
  final UserAddressModel? selectedUserAddress;
  const UserAddressPaginatedState({
    super.hasReachedEnd,
    super.items,
    super.nextCursor,
    this.selectedUserAddress,
  });
  @override
  UserAddressPaginatedState copyWith({
    List<UserAddressModel>? items,
    String? nextCursor,
    bool? hasReachedEnd,
    bool setNextCursorToNull = false,
    UserAddressModel? selectedUserAddress,
    bool setSelectedUserAddressToNull = false,
  }) {
    return UserAddressPaginatedState(
      items: items ?? this.items,
      nextCursor: setNextCursorToNull ? null : (nextCursor ?? this.nextCursor),
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      selectedUserAddress: setSelectedUserAddressToNull
          ? null
          : (selectedUserAddress ?? this.selectedUserAddress),
    );
  }

  @override
  List<Object?> get props => [...super.props, selectedUserAddress];
}

class AddressNotifier extends AsyncNotifier<UserAddressPaginatedState> {
  @override
  Future<UserAddressPaginatedState> build() async {
    final response = await ref.read(addressRepoProvider).getUserAddresses();
    return UserAddressPaginatedState(
      items: response.results,
      nextCursor: response.next,
      hasReachedEnd: response.next == null,
      selectedUserAddress:
          response.results.firstWhereOrNull((item) => item.isDefault),
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.valueOrNull;

    if (currentState == null || currentState.hasReachedEnd) {
      return;
    }
    state = AsyncLoading<UserAddressPaginatedState>().copyWithPrevious(state);
    try {
      final repo = ref.read(addressRepoProvider);
      final response =
          await repo.getUserAddresses(url: currentState.nextCursor);

      final newItems = [...currentState.items, ...response.results];

      state = AsyncData(
        UserAddressPaginatedState(
          items: newItems,
          nextCursor: response.next,
          hasReachedEnd: response.next == null,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> setDefault(int addressId) async {
    final repo = ref.read(addressRepoProvider);
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    //(Optimistic Update)
    final originalItems = currentState.items;
    final newItems = originalItems
        .map((addr) => addr.copyWith(isDefault: addr.id == addressId))
        .toList();
    state = AsyncData(currentState.copyWith(items: newItems));

    try {
      await repo.setDefaultAddress(addressId);
    } catch (e) {
      state = AsyncData(currentState.copyWith(items: originalItems));
    }
  }

  void addAddressLocally(UserAddressModel newAddress) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final updatedItems = [newAddress, ...currentState.items];
    state = AsyncData(currentState.copyWith(items: updatedItems));
  }

  void selectUserAddress(UserAddressModel address) {
    if (!state.hasValue) return;

    state = AsyncData(state.value!.copyWith(
      selectedUserAddress: address,
      setSelectedUserAddressToNull:
          state.value?.selectedUserAddress?.id == address.id,
    ));
  }

  void updateAddressLocally(UserAddressModel updatedAddress) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final updatedItems = currentState.items.map((addr) {
      return addr.id == updatedAddress.id ? updatedAddress : addr;
    }).toList();
    state = AsyncData(currentState.copyWith(items: updatedItems));
  }

  Future<void> deleteAddress(int addressId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final originalItems = currentState.items;

    final newItems =
        originalItems.where((addr) => addr.id != addressId).toList();

    state = AsyncData(currentState.copyWith(items: newItems));

    try {
      await ref.read(addressRepoProvider).deleteAddress(addressId);
    } catch (e) {
      state = AsyncData(currentState.copyWith(items: originalItems));
      AppMessage.showInfo(message: "حدث خطأ ما غير معروف ");
    }
  }
}

final addressNotifierProvider =
    AsyncNotifierProvider<AddressNotifier, UserAddressPaginatedState>(() {
  return AddressNotifier();
});
