import 'package:equatable/equatable.dart';

class FilterModel extends Equatable {
  final String id;
  final String name;

  const FilterModel({
    required this.id,
    required this.name,
  });

  FilterModel copyWith({
    String? id,
    String? name,
  }) {
    return FilterModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  @override
  List<Object> get props => [id, name];
}
