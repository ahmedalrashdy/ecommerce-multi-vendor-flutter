import 'package:equatable/equatable.dart';

class CartItemModel extends Equatable {
  final int id;
  final int quantity;
  final double subTotal;
  final DateTime createdAt;
  final int variantId;
  final int productId;
  final String productName;
  final String? imageUrl;
  final double price;
  final Map<String, dynamic> options;
  final int storeId;
  final String storeName;
  final bool isUpdating;
  final bool isSelected;

  const CartItemModel({
    required this.id,
    required this.quantity,
    required this.subTotal,
    required this.createdAt,
    required this.variantId,
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.price,
    required this.options,
    required this.storeId,
    required this.storeName,
    required this.isUpdating,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [
        id,
        quantity,
        subTotal,
        createdAt,
        variantId,
        productId,
        productName,
        imageUrl,
        price,
        options,
        storeId,
        storeName,
        isUpdating,
        isSelected
      ];

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      quantity: json['quantity'],
      subTotal: double.parse(json['sub_total'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      variantId: json['variant_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      imageUrl: json['image_url'],
      price: double.parse(json['price'].toString()),
      options: Map<String, dynamic>.from(json['options']),
      storeId: json['store_id'],
      storeName: json['store_name'],
      isUpdating: false,
      isSelected: false,
    );
  }

  static List<CartItemModel> fromList(List<dynamic> list) =>
      list.map((item) => CartItemModel.fromJson(item)).toList();

  CartItemModel copyWith({
    int? id,
    int? quantity,
    double? subTotal,
    bool? isUpdating,
    bool? isSelected,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      subTotal: subTotal ?? this.subTotal,
      createdAt: createdAt,
      variantId: variantId,
      productId: productId,
      productName: productName,
      imageUrl: imageUrl,
      price: price,
      options: options,
      storeId: storeId,
      storeName: storeName,
      isUpdating: isUpdating ?? this.isUpdating,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
