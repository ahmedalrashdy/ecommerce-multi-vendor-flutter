import 'package:ecommerce/core/helpers/app_exception.dart';
import 'package:ecommerce/core/models/plateform_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce/core/consts/api_endpoints.dart';
import 'package:ecommerce/core/enums/enums.dart';
import '../../../core/providers/providers.dart';
import 'featured_products_state.dart';

class FeaturedProductsNotifier extends StateNotifier<FeaturedProductsState> {
  final Ref _ref;
  final ScrollController scrollController = ScrollController();

  FeaturedProductsNotifier(this._ref) : super(FeaturedProductsState.initial()) {
    _initialize();
  }

  void _initialize() {
    scrollController.addListener(_onScroll);
    fetchPlatformCategories();
    fetchInitialProducts();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent * 0.9 &&
        !state.isLoadingMore) {
      fetchNextPage();
    }
  }

  Future<void> fetchPlatformCategories() async {
    state = state.copyWith(fetchCategoriesStatus: AsyncStatus.loading);
    final categoryRepo = _ref.read(platformCategoryRepoProvider);
    try {
      List<PlatformCategory> result =
          await categoryRepo.getFeaturedCategories();
      state = state.copyWith(
        fetchCategoriesStatus: AsyncStatus.success,
        categories: result,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        fetchCategoriesStatus: AsyncStatus.failure,
        fetchCategoriesError: e.drfErrors.allMessages,
      );
    }
  }

  Future<void> fetchInitialProducts() async {
    state = state.copyWith(
      fetchProductsStatus: AsyncStatus.loading,
      isLoadingMore: false,
    );

    final productRepo = _ref.read(productRepoProvider);
    final params = <String, String>{
      'sort-by': state.sortBy == 'rating' ? 'top-rated' : 'top-sale',
    };
    if (state.selectedCategoryId != null) {
      params['platform_category'] = state.selectedCategoryId!.toString();
    }

    try {
      final result = await productRepo.getFeaturedProducts(
        url: ApiEndpoint.featuredProducts,
        params: params,
      );
      state = state.copyWith(
        fetchProductsStatus: AsyncStatus.success,
        paginatedResponse: result,
      );
    } catch (e) {
      state = state.copyWith(
          fetchProductsStatus: AsyncStatus.failure,
          fetchProductsError: e.toString());
    }
  }

  Future<void> fetchNextPage() async {
    if (state.paginatedResponse.next == null || state.isLoadingMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);
    final productRepo = _ref.read(productRepoProvider);

    final result = await productRepo.getFeaturedProducts(
      url: state.paginatedResponse.next!,
    );
    final newProducts = [...state.paginatedResponse.results, ...result.results];
    state = state.copyWith(
      paginatedResponse: result.copyWith(results: newProducts),
    );
    state = state.copyWith(isLoadingMore: false);
  }

  // --- UI-triggered Methods ---
  void selectCategory(int? categoryId) {
    if (state.selectedCategoryId != categoryId) {
      state = state.copyWith(
        selectedCategoryId: categoryId,
        clearSelectedCategory: categoryId == null,
      );
      fetchInitialProducts();
    }
  }

  void selectStoreCategory(int? categoryId) {
    if (state.selectedStoreCategoryId != categoryId) {
      state = state.copyWith(
        selectedStoreCategoryId: categoryId,
        clearSelectedStoreCategory: categoryId == null,
      );
      // fetchInitialProducts();
    }
  }

  void selectSortBy(String newSortBy) {
    if (state.sortBy != newSortBy) {
      state = state.copyWith(sortBy: newSortBy);
      fetchInitialProducts();
    }
  }
}
