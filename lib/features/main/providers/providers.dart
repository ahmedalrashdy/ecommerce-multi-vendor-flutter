import 'package:ecommerce/core/models/store_model.dart';
import 'package:ecommerce/core/repos/store_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce/features/main/models/offer_model.dart';
import 'package:ecommerce/features/main/services/mock_api_service.dart';

import 'featured_products_notifier.dart';
import 'featured_products_state.dart';

// مزود خدمة API المزيفة
final mockApiServiceProvider = Provider<MockApiService>((ref) {
  return MockApiService();
});

// مزود العروض
final offersProvider = FutureProvider<List<OfferModel>>((ref) async {
  final apiService = ref.watch(mockApiServiceProvider);
  return apiService.getOffers();
});

final featuredStoresProvider = FutureProvider.family<List<StoreModel>, int?>(
    (ref, platformCategory) async {
  final data = await ref.read(storeRepoProvider).getStores(params: {
    if (platformCategory != null)
      "platform_category": platformCategory.toString()
  });
  return data.results;
});

final selectedFeaturedStoreCategoryProvider =
    StateProvider.autoDispose<int?>((ref) => null);

final featuredProductsProvider = StateNotifierProvider.autoDispose<
    FeaturedProductsNotifier, FeaturedProductsState>((ref) {
  return FeaturedProductsNotifier(ref);
});
