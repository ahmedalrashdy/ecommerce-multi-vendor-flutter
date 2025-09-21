class OfferModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int? discountPercentage;
  final String? productId;
  final String? storeId;
  final DateTime validUntil;
  final String couponCode;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.discountPercentage,
    this.productId,
    this.storeId,
    required this.validUntil,
    required this.couponCode,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      discountPercentage: json['discount_percentage'],
      productId: json['product_id'],
      storeId: json['store_id'],
      validUntil: DateTime.parse(json['valid_until']),
      couponCode: json['coupon_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'discount_percentage': discountPercentage,
      'product_id': productId,
      'store_id': storeId,
      'valid_until': validUntil.toIso8601String(),
      'coupon_code': couponCode,
    };
  }
}