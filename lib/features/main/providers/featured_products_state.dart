import 'package:ecommerce/core/enums/enums.dart';
import 'package:ecommerce/core/models/paginated_response.dart';
import 'package:ecommerce/core/models/plateform_category_model.dart';
import 'package:ecommerce/core/models/product_model.dart';
import 'package:flutter/material.dart';

class FeaturedProductsState {
  // --- State for Products ---
  final AsyncStatus fetchProductsStatus;
  final PaginatedResponse<ProductModel> paginatedResponse;
  final String? fetchProductsError;

  // --- State for Categories ---
  final AsyncStatus fetchCategoriesStatus;
  final List<PlatformCategory> categories;
  final String? fetchCategoriesError;

  //store category
  final int? selectedStoreCategoryId;
  // --- Filter & Sort State ---
  final int? selectedCategoryId;
  final String sortBy; // 'rating', 'sales'

  // --- Pagination State ---
  final bool isLoadingMore;

  FeaturedProductsState({
    required this.fetchProductsStatus,
    required this.paginatedResponse,
    this.fetchProductsError,
    required this.fetchCategoriesStatus,
    required this.categories,
    this.fetchCategoriesError,
    this.selectedCategoryId,
    required this.sortBy,
    required this.isLoadingMore,
    this.selectedStoreCategoryId,
  });

  // الحالة الابتدائية
  factory FeaturedProductsState.initial() {
    return FeaturedProductsState(
      fetchProductsStatus: AsyncStatus.idle,
      paginatedResponse: PaginatedResponse<ProductModel>(results: []),
      fetchCategoriesStatus: AsyncStatus.idle,
      categories: [],
      sortBy: 'rating',
      isLoadingMore: false,
      selectedCategoryId: null,
      selectedStoreCategoryId: null,
    );
  }

  // دالة `copyWith` مهمة جداً لإنشاء نسخة جديدة من الحالة مع تعديل بعض القيم
  FeaturedProductsState copyWith({
    AsyncStatus? fetchProductsStatus,
    PaginatedResponse<ProductModel>? paginatedResponse,
    String? fetchProductsError,
    AsyncStatus? fetchCategoriesStatus,
    List<PlatformCategory>? categories,
    String? fetchCategoriesError,
    int? selectedCategoryId, // يمكن أن يكون null
    int? selectedStoreCategoryId,
    bool? clearSelectedCategory,
    bool? clearSelectedStoreCategory,
    String? sortBy,
    bool? isLoadingMore,
    ScrollController? scrollController,
  }) {
    return FeaturedProductsState(
      fetchProductsStatus: fetchProductsStatus ?? this.fetchProductsStatus,
      paginatedResponse: paginatedResponse ?? this.paginatedResponse,
      fetchProductsError: fetchProductsError ?? this.fetchProductsError,
      fetchCategoriesStatus:
          fetchCategoriesStatus ?? this.fetchCategoriesStatus,
      categories: categories ?? this.categories,
      fetchCategoriesError: fetchCategoriesError ?? this.fetchCategoriesError,
      selectedCategoryId: clearSelectedCategory == true
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      sortBy: sortBy ?? this.sortBy,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedStoreCategoryId: clearSelectedStoreCategory == true
          ? null
          : selectedStoreCategoryId ?? this.selectedStoreCategoryId,
    );
  }
}
