import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/store_model.dart';
import '../../../core/repos/search_repo.dart';
import 'search_state.dart';

class StoreSearchNotifier extends StateNotifier<SearchState<StoreModel>> {
  final SearchRepo _searchRepo;
  String _currentQuery = '';

  StoreSearchNotifier(this._searchRepo) : super(const SearchState());
  Future<void> refresh() async {
    searchStores(_currentQuery);
  }

  Future<void> searchStores(String query) async {
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
      final response = await _searchRepo.searchStores(params: {
        "search": _currentQuery,
      });
      state = state.copyWith(
        items: response.results,
        nextPageUrl: response.next,
        isLoading: false,
        isFirstFetch: false,
        clearNextPageUrl: response.next == null,
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
      final response = await _searchRepo.searchStores(url: state.nextPageUrl!);
      state = state.copyWith(
        items: [...state.items, ...response.results],
        nextPageUrl: response.next,
        isLoading: false,
        clearNextPageUrl: response.next == null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}

// إنشاء الـ Provider
final storeSearchProvider = StateNotifierProvider.autoDispose<
    StoreSearchNotifier, SearchState<StoreModel>>(
  (ref) => StoreSearchNotifier(ref.watch(searchRepoProvider)),
);
