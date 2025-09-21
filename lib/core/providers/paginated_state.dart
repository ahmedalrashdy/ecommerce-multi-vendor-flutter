import 'package:equatable/equatable.dart';

class PaginationState<T> extends Equatable {
  final List<T> items;
  final String? nextCursor;
  final bool hasReachedEnd;

  const PaginationState({
    this.items = const [],
    this.nextCursor,
    this.hasReachedEnd = false,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    String? nextCursor,
    bool? hasReachedEnd,
    bool setNextCursorToNull = false,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      nextCursor: setNextCursorToNull ? null : nextCursor ?? this.nextCursor,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [items, nextCursor, hasReachedEnd];
}
