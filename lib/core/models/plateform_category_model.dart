class PlatformCategory {
  final int id;
  final String name;
  final String? imageUrl;

  PlatformCategory({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  /// fromJson
  factory PlatformCategory.fromJson(Map<String, dynamic> json) {
    return PlatformCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  /// fromList
  static List<PlatformCategory> fromList(List<dynamic> list) {
    return list.map((e) => PlatformCategory.fromJson(e)).toList();
  }

  /// toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
    };
  }

  /// copyWith
  PlatformCategory copyWith({
    int? id,
    String? name,
    String? imageUrl,
    bool? isFeatured,
  }) {
    return PlatformCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'PlatformCategory(id: $id, name: $name, imageUrl: $imageUrl,)';
  }
}
