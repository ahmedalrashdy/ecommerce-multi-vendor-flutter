import 'package:ecommerce/core/enums/enums.dart';
import 'package:ecommerce/features/products/models/product_detail_model.dart';
import 'package:flutter/material.dart';

class ProductDetailState {
  // --- Page State ---
  final AsyncStatus status;
  final String? fetchError;

  // --- Product Data State ---
  final ProductDetailModel? product;
  final ProductVariantModel? selectedVariant;
  final Map<String, String> selectedOptions;
  final List<ProductImageModel> currentImages;
  final Map<String, List<String>> availableOptions;

  final PageController imagePageController;

  const ProductDetailState({
    required this.status,
    this.fetchError,
    this.product,
    this.selectedVariant,
    required this.selectedOptions,
    required this.currentImages,
    required this.availableOptions,
    required this.imagePageController,
  });

  // الحالة الابتدائية
  factory ProductDetailState.initial() {
    return ProductDetailState(
      status: AsyncStatus.idle,
      selectedOptions: {},
      currentImages: [],
      availableOptions: {},
      imagePageController: PageController(),
    );
  }

  // دالة copyWith
  ProductDetailState copyWith({
    AsyncStatus? status,
    String? fetchError,
    ProductDetailModel? product,
    ProductVariantModel? selectedVariant,
    Map<String, String>? selectedOptions,
    List<ProductImageModel>? currentImages,
    Map<String, List<String>>? availableOptions,
    PageController? imagePageController,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      fetchError: fetchError ?? this.fetchError,
      product: product ?? this.product,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      currentImages: currentImages ?? this.currentImages,
      availableOptions: availableOptions ?? this.availableOptions,
      imagePageController: imagePageController ?? this.imagePageController,
    );
  }
}
