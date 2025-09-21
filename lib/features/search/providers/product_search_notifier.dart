import 'dart:async';
import 'package:ecommerce/core/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repos/search_repo.dart';
import 'search_state.dart';

class ProductSearchNotifier extends StateNotifier<SearchState<ProductModel>> {
  final SearchRepo _searchRepo;
  String _currentQuery = '';

  ProductSearchNotifier(this._searchRepo) : super(const SearchState());

  Future<void> refresh() async {
    searchProducts(_currentQuery);
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      state = const SearchState();
      return;
    }
    state = const SearchState();
    _currentQuery = query;
    state = state.copyWith(
      isLoading: true,
      isFirstFetch: true,
      items: [],
      clearError: true,
      clearNextPageUrl: true,
    );

    try {
      final response =
          await _searchRepo.searchProducts(params: {"search": _currentQuery});
      state = state.copyWith(
        items: response.results,
        nextPageUrl: response.next,
        isLoading: false,
        isFirstFetch: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isFirstFetch: false,
      );
    }
  }

  Future<void> fetchNextPage() async {
    if (!state.canFetchMore) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response =
          await _searchRepo.searchProducts(url: state.nextPageUrl!);
      state = state.copyWith(
        items: [...state.items, ...response.results],
        nextPageUrl: response.next,
        isLoading: false,
        clearNextPageUrl: response.next == null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final productSearchProvider = StateNotifierProvider.autoDispose<
    ProductSearchNotifier, SearchState<ProductModel>>(
  (ref) => ProductSearchNotifier(ref.watch(searchRepoProvider)),
);
