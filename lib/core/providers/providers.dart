import 'package:ecommerce/core/enums/enums.dart';
import 'package:ecommerce/core/providers/platform_category_notifier.dart';
import 'package:ecommerce/core/repos/plateform_category_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repos/product_repo.dart';

final yemenCityProvider = StateProvider.autoDispose
    .family<List<YemeniCity>, String>((ref, String id) {
  return [YemeniCity.all];
});
final productSortByProvider =
    StateProvider.autoDispose.family<ProductSortBy, String>((ref, id) {
  return ProductSortBy.topRated;
});
final storeSortByProvider =
    StateProvider.autoDispose.family<StoreSortBy, String>((ref, id) {
  return StoreSortBy.topRated;
});

final platformCategoryProvider =
    AsyncNotifierProvider<PlatformCategoryNotifier, PlatformCategoryState>(() {
  return PlatformCategoryNotifier();
});

//==============================================
//repos
final platformCategoryRepoProvider = Provider((ref) {
  return PlatformCategoryRepo();
});

final productRepoProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});
