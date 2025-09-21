import 'dart:async';
import 'package:ecommerce/core/models/plateform_category_model.dart';
import 'package:ecommerce/core/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlatformCategoryState {
  final List<PlatformCategory> pCategories;
  final int? productListSelectedId;

  PlatformCategoryState({
    required this.pCategories,
    this.productListSelectedId,
  });

  PlatformCategoryState copyWith({
    List<PlatformCategory>? pCategories,
    int? productListSelectedId,
  }) {
    return PlatformCategoryState(
      pCategories: pCategories ?? this.pCategories,
      productListSelectedId:
          productListSelectedId ?? this.productListSelectedId,
    );
  }
}

class PlatformCategoryNotifier extends AsyncNotifier<PlatformCategoryState> {
  @override
  FutureOr<PlatformCategoryState> build() async {
    return fetchAll();
  }

  Future<PlatformCategoryState> fetchAll() async {
    final cateRepo = ref.read(platformCategoryRepoProvider);
    final data = await cateRepo.getFeaturedCategories();
    return PlatformCategoryState(pCategories: data);
  }
}
