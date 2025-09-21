class ProductDetailModel {
  final int id;
  final int storeId;
  final int? categoryId;
  final String name;
  final String description;
  final String storeName;
  final String? categoryName;
  final double rating;
  final Map<String, String> specifications;
  final bool isFavorite;
  final List<ProductVariantModel> variants;
  final List<ProductImageModel> generalImages;

  ProductDetailModel({
    required this.id,
    required this.storeId,
    this.categoryId,
    required this.name,
    required this.description,
    required this.storeName,
    this.categoryName,
    required this.rating,
    required this.specifications,
    required this.isFavorite,
    required this.variants,
    required this.generalImages,
  });

  /// ✅ fromJson
  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'],
      storeId: json['store_id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      storeName: json['store_name'],
      categoryName: json['category_name'],
      rating: (json['rating'] as num).toDouble(),
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      isFavorite: json['is_favorite'] ?? false,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => ProductVariantModel.fromJson(e))
              .toList() ??
          [],
      generalImages: (json['general_images'] as List<dynamic>?)
              ?.map((e) => ProductImageModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// ✅ toJson
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "store_id": storeId,
      "category_id": categoryId,
      "name": name,
      "description": description,
      "store_name": storeName,
      "category_name": categoryName,
      "rating": rating,
      "specifications": specifications,
      "is_favorite": isFavorite,
      "variants": variants.map((e) => e.toJson()).toList(),
      "general_images": generalImages.map((e) => e.toJson()).toList(),
    };
  }

  /// ✅ copyWith
  ProductDetailModel copyWith({
    int? id,
    int? storeId,
    int? categoryId,
    String? name,
    String? description,
    String? storeName,
    String? categoryName,
    double? rating,
    Map<String, String>? specifications,
    bool? isFavorite,
    List<ProductVariantModel>? variants,
    List<ProductImageModel>? generalImages,
  }) {
    return ProductDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      storeName: storeName ?? this.storeName,
      categoryName: categoryName ?? this.categoryName,
      rating: rating ?? this.rating,
      specifications: specifications ?? this.specifications,
      isFavorite: isFavorite ?? this.isFavorite,
      variants: variants ?? this.variants,
      generalImages: generalImages ?? this.generalImages,
      storeId: storeId ?? this.storeId,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}

// ------------------ ProductVariantModel ------------------

class ProductVariantModel {
  final int id;
  final double price;
  final String? sku;
  final int? stockQuantity;
  final Map<String, String> options;
  final List<ProductImageModel> images;
  final int cartQuantity;
  ProductVariantModel(
      {required this.id,
      required this.price,
      this.sku,
      this.stockQuantity,
      required this.options,
      required this.images,
      required this.cartQuantity});

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      sku: json['sku'],
      stockQuantity: json['stock_quantity'],
      options: Map<String, String>.from(json['options'] ?? {}),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImageModel.fromJson(e))
              .toList() ??
          [],
      cartQuantity: json["cart_quantity"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "price": price.toStringAsFixed(2),
      "sku": sku,
      "stockQuantity": stockQuantity,
      "options": options,
      "images": images.map((e) => e.toJson()).toList(),
      "cart_quantity": cartQuantity,
    };
  }

  ProductVariantModel copyWith({
    int? id,
    double? price,
    String? sku,
    int? stockQuantity,
    Map<String, String>? options,
    List<ProductImageModel>? images,
    int? cartQuantity,
  }) {
    return ProductVariantModel(
      id: id ?? this.id,
      price: price ?? this.price,
      sku: sku ?? this.sku,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      options: options ?? this.options,
      images: images ?? this.images,
      cartQuantity: cartQuantity ?? this.cartQuantity,
    );
  }
}

class ProductImageModel {
  final String imageUrl;
  final int displayOrder;

  ProductImageModel({
    required this.imageUrl,
    required this.displayOrder,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      imageUrl: json['image_url'],
      displayOrder: json['display_order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image_url": imageUrl,
      "display_order": displayOrder,
    };
  }

  ProductImageModel copyWith({
    String? imageUrl,
    int? displayOrder,
  }) {
    return ProductImageModel(
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}
