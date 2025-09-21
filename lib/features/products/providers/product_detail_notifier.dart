import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce/core/enums/enums.dart';
import 'package:collection/collection.dart';

import '../../../core/providers/providers.dart';
import '../models/product_detail_model.dart';
import 'product_detail_state.dart';

class ProductDetailNotifier extends StateNotifier<ProductDetailState> {
  final Ref _ref;
  final int _productId;

  ProductDetailNotifier(this._ref, this._productId)
      : super(ProductDetailState.initial()) {
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    state = state.copyWith(status: AsyncStatus.loading);

    final productRepo = _ref.read(productRepoProvider);
    try {
      final result = await productRepo.getProductDetails(_productId);
      state = state.copyWith(
        status: AsyncStatus.success,
        product: result,
      );
      // استدعاء الدوال المساعدة لتجهيز الحالة
      _generateAvailableOptions();
      _initializeDefaultVariant();
    } on AppException catch (e) {
      state = state.copyWith(
        status: AsyncStatus.failure,
        fetchError: e.drfErrors.allMessages,
      );
    }
  }

  void _generateAvailableOptions() {
    final product = state.product;
    if (product == null || product.variants.isEmpty) return;

    final optionsMap = <String, Set<String>>{};
    for (final variant in product.variants) {
      variant.options.forEach((key, value) {
        optionsMap.putIfAbsent(key, () => <String>{}).add(value);
      });
    }

    state = state.copyWith(
      availableOptions:
          optionsMap.map((key, value) => MapEntry(key, value.toList())),
    );
  }

  void _initializeDefaultVariant() {
    final product = state.product;
    if (product != null && product.variants.isNotEmpty) {
      final defaultVariant = product.variants.first;
      state = state.copyWith(
        selectedVariant: defaultVariant,
        selectedOptions: Map.from(defaultVariant.options),
        currentImages: defaultVariant.images.isNotEmpty
            ? defaultVariant.images
            : product.generalImages,
      );
    } else if (product != null) {
      state = state.copyWith(currentImages: product.generalImages);
    }
  }

  // في ProductDetailNotifier

  void onOptionSelected(String optionKey, String value) {
    // 1. إذا كان المستخدم يضغط على خيار محدد بالفعل، قم بإلغاء تحديده.
    if (state.selectedOptions[optionKey] == value) {
      final newSelectedOptions =
          Map<String, String>.from(state.selectedOptions);
      newSelectedOptions.remove(optionKey);
      state = state.copyWith(
        selectedOptions: newSelectedOptions,
        selectedVariant: null, // لم يعد هناك variant محدد
      );
      return;
    }

    // 2. تحديث الخيار المحدد من قبل المستخدم
    final newSelectedOptions = Map<String, String>.from(state.selectedOptions);
    newSelectedOptions[optionKey] = value;

    // 3. (الجزء الذكي) التحقق من صلاحية الخيارات الأخرى وإبطالها إذا لزم الأمر
    final product = state.product!;
    final keysToReset = <String>[];

    newSelectedOptions.forEach((key, val) {
      if (key == optionKey) return; // تخطى الخيار الذي تم تغييره للتو

      // تحقق مما إذا كان الخيار الآخر (val) لا يزال صالحًا مع التحديد الجديد.
      // نستخدم نفس منطق isOptionAvailable ولكن بشكل معكوس قليلاً.
      final tempOptionsForCheck = {optionKey: value, key: val};

      final isStillValid = product.variants.any((variant) {
        return tempOptionsForCheck.entries
            .every((entry) => variant.options[entry.key] == entry.value);
      });

      if (!isStillValid) {
        keysToReset.add(key);
      }
    });

    // إزالة الخيارات التي أصبحت غير صالحة
    for (final key in keysToReset) {
      newSelectedOptions.remove(key);
    }

    // 4. محاولة العثور على variant يطابق الخيارات الصالحة المتبقية
    final newVariant = _findMatchingVariant(newSelectedOptions);

    // 5. تحديث الحالة النهائية دفعة واحدة
    state = state.copyWith(
      selectedOptions: newSelectedOptions,
      selectedVariant: newVariant,
      currentImages: (newVariant != null && newVariant.images.isNotEmpty)
          ? newVariant.images
          : product.generalImages,
    );
  }

// دالة مساعدة للعثور على variant يطابق *كل* الخيارات المحددة
  ProductVariantModel? _findMatchingVariant(Map<String, String> options) {
    final product = state.product;
    if (product == null || options.isEmpty) return null;

    // يجب أن يكون عدد الخيارات المحددة هو نفس عدد الخيارات في الـ variant
    final optionKeysCount = product.variants.first.options.keys.length;
    if (options.keys.length != optionKeysCount) {
      return null; // لم يتم تحديد جميع الخيارات بعد
    }

    return product.variants.firstWhereOrNull(
      (variant) => const MapEquality().equals(variant.options, options),
    );
  }

// قم باستدعاء هذه الدالة في onOptionSelected

  // في ProductDetailNotifier

  bool isOptionAvailable(String optionKey, String value) {
    final product = state.product;
    if (product == null) return false;

    // 1. أنشئ نسخة من الخيارات المحددة حاليًا، ولكن بدون الخيار الذي نختبره.
    // هذا يسمح لنا بالتحقق من التوافر بغض النظر عن القيمة الحالية لهذا الخيار.
    final otherSelectedOptions =
        Map<String, String>.from(state.selectedOptions);
    otherSelectedOptions.remove(optionKey);

    // 2. ابحث عن أي variant يطابق الخيارات الأخرى المحددة، ويحتوي أيضًا على الخيار والقيمة التي نختبرها.
    return product.variants.any((variant) {
      // 2a. تحقق أولاً مما إذا كان الـ variant يحتوي على الخيار والقيمة التي نختبرها.
      if (variant.options[optionKey] != value) {
        return false;
      }

      // 2b. ثم، تحقق مما إذا كان هذا الـ variant يطابق جميع الخيارات الأخرى المحددة.
      bool matchesOthers = true;
      otherSelectedOptions.forEach((key, val) {
        if (variant.options[key] != val) {
          matchesOthers = false;
        }
      });

      return matchesOthers;
    });
  }

  @override
  void dispose() {
    state.imagePageController.dispose();
    super.dispose();
  }
}

final productDetailNotifierProvider = StateNotifierProvider.autoDispose
    .family<ProductDetailNotifier, ProductDetailState, int>((ref, productId) {
  return ProductDetailNotifier(ref, productId);
});
