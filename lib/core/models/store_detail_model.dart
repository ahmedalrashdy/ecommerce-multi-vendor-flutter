import 'package:equatable/equatable.dart';

class StoreDetailModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String? logoUrl;
  final String? coverImageUrl;
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

  const StoreDetailModel({
    required this.id,
    required this.name,
    required this.description,
    this.logoUrl,
    this.coverImageUrl,
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

  @override
  List<Object?> get props =>
      [id, name, /* ... أضف باقي الحقول ... */ isFavorite];

  factory StoreDetailModel.fromJson(Map<String, dynamic> json) {
    return StoreDetailModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logoUrl: json['logo'],
      coverImageUrl: json['cover_image'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      city: json['city'],
      platformCategoryName: json['platform_category_name'],
      // لاحظ أن الـ API يرجع ID كـ String، لذا نقوم بتحويله
      platformCategoryId: int.parse(json['platform_category_id']),
      averageRating: (json['average_rating'] as num).toDouble(),
      productCount: json['product_count'],
      favoritesCount: json['favorites_count'],
      reviewCount: json['review_count'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}
