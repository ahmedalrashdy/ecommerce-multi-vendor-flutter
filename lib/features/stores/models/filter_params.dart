import 'package:flutter/foundation.dart';

@immutable
class SecondaryFilterParams {
  final String? city;
  final String sortBy; // 'rating', 'productsCount', 'name'

  const SecondaryFilterParams({
    this.city,
    this.sortBy = 'rating',
  });

  // copyWith and equality
  SecondaryFilterParams copyWith({
    String? city,
    String? sortBy,
  }) {
    return SecondaryFilterParams(
      city: city ?? this.city,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SecondaryFilterParams &&
        other.city == city &&
        other.sortBy == sortBy;
  }

  @override
  int get hashCode => city.hashCode ^ sortBy.hashCode;
}
