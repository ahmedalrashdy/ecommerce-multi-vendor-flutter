class PaginatedResponse<T> {
  final String? next;
  final String? previous;
  final List<T> results;

  PaginatedResponse({
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return PaginatedResponse(
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
    );
  }

  PaginatedResponse<T> copyWith({
    String? next,
    String? previous,
    List<T>? results,
  }) {
    return PaginatedResponse<T>(
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
    );
  }
}
