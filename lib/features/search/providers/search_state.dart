import 'package:flutter/foundation.dart';

@immutable
class SearchState<T> {
  final List<T> items;
  final bool isFirstFetch;
  final bool isLoading;
  final String? nextPageUrl;
  final String? error;

  const SearchState({
    this.items = const [],
    this.isFirstFetch = true,
    this.isLoading = false,
    this.nextPageUrl,
    this.error,
  });

  // Getter to check if more pages can be fetched
  bool get canFetchMore => nextPageUrl != null && !isLoading;

  // copyWith method to create a new instance with updated values
  SearchState<T> copyWith({
    List<T>? items,
    bool? isFirstFetch,
    bool? isLoading,
    String? nextPageUrl,
    String? error,
    bool clearNextPageUrl = false,
    bool clearError = false, // Helper to nullify the error
  }) {
    return SearchState<T>(
      items: items ?? this.items,
      isFirstFetch: isFirstFetch ?? this.isFirstFetch,
      isLoading: isLoading ?? this.isLoading,
      nextPageUrl: clearNextPageUrl ? null : (nextPageUrl ?? this.nextPageUrl),
      error: clearError ? null : error ?? this.error,
    );
  }
}
