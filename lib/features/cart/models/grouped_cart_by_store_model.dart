import 'package:ecommerce/features/cart/models/cart_item_model.dart';

class GroupedCartByStoreModel {
  final int id;
  final String name;
  final String? logo;
  final String? coverImage;
  final double storeSubTotal;
  final List<CartItemModel> items;
  GroupedCartByStoreModel({
    required this.id,
    required this.name,
    this.logo,
    this.coverImage,
    required this.storeSubTotal,
    required this.items,
  });

  factory GroupedCartByStoreModel.fromJson(Map<String, dynamic> json) {
    return GroupedCartByStoreModel(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      coverImage: json['cover_image'],
      storeSubTotal: (json['store_sub_total'] as num).toDouble(),
      items: CartItemModel.fromList(json['items']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'cover_image': coverImage,
      'store_sub_total': storeSubTotal,
      'items': items,
    };
  }

  GroupedCartByStoreModel copyWith({
    int? id,
    String? name,
    String? logo,
    String? coverImage,
    double? storeSubTotal,
    List<CartItemModel>? items,
  }) {
    return GroupedCartByStoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      coverImage: coverImage ?? this.coverImage,
      storeSubTotal: storeSubTotal ?? this.storeSubTotal,
      items: items ?? this.items,
    );
  }
}
