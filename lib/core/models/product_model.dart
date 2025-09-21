class ProductModel {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double discountPercentage;
  final double finalPrice;
  final int storeId;
  final String storeName;
  final int? categoryId;
  final String? categoryName;
  final double rating;

  final bool isFavorite;
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.discountPercentage = 0,
    required this.finalPrice,
    required this.storeId,
    required this.storeName,
    required this.categoryId,
    required this.categoryName,
    required this.rating,
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final double price = double.parse(json['price']);
    final double? discountPercentage = json['discount_percentage'];
    final double finalPrice = discountPercentage != null
        ? price - (price * discountPercentage / 100)
        : price;

    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      price: price,
      discountPercentage: json['discount_percentage'] ?? 0,
      finalPrice: finalPrice,
      storeId: json['store_id'],
      storeName: json['store_name'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      rating: (json['rating'] as num).toDouble(),
      isFavorite: json['is_favorite'] ?? false,
    );
  }
  static List<ProductModel> fromList(List<dynamic> data) {
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'discount_percentage': discountPercentage,
      'final_price': finalPrice,
      'store_id': storeId,
      'store_name': storeName,
      'category_id': categoryId,
      'category_name': categoryName,
      'rating': rating,
      'is_favorite': isFavorite,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    double? discountPercentage,
    double? finalPrice,
    int? storeId,
    String? storeName,
    int? categoryId,
    String? categoryName,
    double? rating,
    int? salesCount,
    bool? isFavorite,
    List<String>? images,
    Map<String, dynamic>? options,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      finalPrice: finalPrice ?? this.finalPrice,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
