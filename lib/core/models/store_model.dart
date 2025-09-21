class StoreModel {
  final int id;
  final String name;
  final String description;
  final String logo;
  final String coverImage;
  final String? openingTime;
  final String? closingTime;
  final String city;
  final String platformCategoryName;
  final int platformCategoryId;
  final double averageRating;
  final int productCount;
  final int favoritesCount;
  final int reviewCount;
  final bool isFavorite;
  StoreModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.coverImage,
    this.openingTime,
    this.closingTime,
    required this.city,
    required this.platformCategoryName,
    required this.platformCategoryId,
    required this.averageRating,
    required this.productCount,
    required this.favoritesCount,
    required this.reviewCount,
    required this.isFavorite,
  });

  /// copyWith
  StoreModel copyWith({
    int? id,
    String? name,
    String? description,
    String? logo,
    String? coverImage,
    String? openingTime,
    String? closingTime,
    String? city,
    String? platformCategoryName,
    int? platformCategoryId,
    double? averageRating,
    int? productCount,
    int? favoritesCount,
    int? reviewCount,
    bool? isFavorite,
  }) {
    return StoreModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        logo: logo ?? this.logo,
        coverImage: coverImage ?? this.coverImage,
        openingTime: openingTime ?? this.openingTime,
        closingTime: closingTime ?? this.closingTime,
        city: city ?? this.city,
        platformCategoryName: platformCategoryName ?? this.platformCategoryName,
        platformCategoryId: platformCategoryId ?? this.platformCategoryId,
        averageRating: averageRating ?? this.averageRating,
        productCount: productCount ?? this.productCount,
        favoritesCount: favoritesCount ?? this.favoritesCount,
        reviewCount: reviewCount ?? this.reviewCount,
        isFavorite: isFavorite ?? this.isFavorite);
  }

  /// fromJson
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      coverImage: json['cover_image'] ?? '',
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      city: json['city'] ?? '',
      platformCategoryName: json['platform_category_name'] ?? '',
      platformCategoryId: json['platform_category_id'] is int
          ? json['platform_category_id']
          : int.tryParse(json['platform_category_id']?.toString() ?? '0') ?? 0,
      averageRating: (json['average_rating'] is num)
          ? (json['average_rating'] as num).toDouble()
          : 0.0,
      productCount: json['product_count'] ?? 0,
      favoritesCount: json['favorites_count'] ?? 0,
      reviewCount: json['review_count'] ?? 0,
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  /// fromList
  static List<StoreModel> fromList(List<dynamic> list) {
    return list.map((e) => StoreModel.fromJson(e)).toList();
  }

  /// toJson (optional, useful for debugging or sending data)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "logo": logo,
      "cover_image": coverImage,
      "opening_time": openingTime,
      "closing_time": closingTime,
      "city": city,
      "platform_category_name": platformCategoryName,
      "platform_category_id": platformCategoryId,
      "average_rating": averageRating,
      "product_count": productCount,
      "favorites_count": favoritesCount,
      "review_count": reviewCount,
      "is_favorite": isFavorite
    };
  }

  bool get isOpen {
    if (openingTime == null || closingTime == null) return false;
    final now = DateTime.now();
    final openParts = openingTime!.split(":");
    final closeParts = closingTime!.split(":");

    final opening = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(openParts[0]),
      int.parse(openParts[1]),
    );

    var closing = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(closeParts[0]),
      int.parse(closeParts[1]),
    );

    // لو الإغلاق بعد منتصف الليل
    if (closing.isBefore(opening)) {
      closing = closing.add(const Duration(days: 1));
    }

    return now.isAfter(opening) && now.isBefore(closing);
  }
}
