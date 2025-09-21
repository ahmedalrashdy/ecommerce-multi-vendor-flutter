import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/product_category_model.dart';
import '../../../core/models/store_detail_model.dart';
import '../../../core/providers/providers.dart';
import '../../../core/repos/store_repo.dart';

final storeDetailProvider =
    FutureProvider.autoDispose.family<StoreDetailModel, int>((ref, storeId) {
  final storeRepo = ref.watch(storeRepoProvider);
  return storeRepo.getStoreDetails(storeId);
});

final storeProductCategoriesProvider = FutureProvider.autoDispose
    .family<List<ProductCategoryModel>, int>((ref, storeId) {
  final productRepo = ref.watch(productRepoProvider);
  return productRepo.getStoreProductCategories(storeId);
});
final selectedStoreParentCategoryProvider =
    StateProvider.autoDispose<int?>((ref) {
  return null;
});

final selectedStoreChildCategoryProvider =
    StateProvider.autoDispose<int?>((ref) {
  ref.watch(selectedStoreParentCategoryProvider);
  return null;
});
