import 'package:equatable/equatable.dart';

class ProductCategoryModel extends Equatable {
  final int id;
  final String name;
  final int? parentId;
  final List<ProductCategoryModel> children;

  const ProductCategoryModel({
    required this.id,
    required this.name,
    this.parentId,
    required this.children,
  });

  @override
  List<Object?> get props => [id, name, parentId, children];

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      children: json['children'] != null
          ? ProductCategoryModel.fromList(json['children'])
          : [],
    );
  }

  static List<ProductCategoryModel> fromList(List<dynamic> list) =>
      list.map((item) => ProductCategoryModel.fromJson(item)).toList();
}
