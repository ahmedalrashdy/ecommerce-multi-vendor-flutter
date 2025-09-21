import 'package:equatable/equatable.dart';

class UserAddressModel extends Equatable {
  final int id;
  final String label;
  final String city;
  final String street;
  final String? landmark;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const UserAddressModel({
    required this.id,
    required this.label,
    required this.city,
    required this.street,
    this.landmark,
    this.latitude,
    this.longitude,
    required this.isDefault,
  });

  @override
  List<Object?> get props =>
      [id, label, city, street, landmark, latitude, longitude, isDefault];

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: json['id'],
      label: json['label'],
      city: json['city'],
      street: json['street'],
      landmark: json['landmark'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      isDefault: json['is_default'],
    );
  }

  /// ✅ Factory to parse list of JSON objects
  factory UserAddressModel.fromList(List<dynamic> list, {int index = 0}) {
    if (list.isEmpty || index < 0 || index >= list.length) {
      throw ArgumentError("Invalid index or empty list");
    }
    return UserAddressModel.fromJson(list[index]);
  }

  static List<UserAddressModel> listFromJson(List<dynamic> list) {
    return list.map((e) => UserAddressModel.fromJson(e)).toList();
  }

  /// ✅ copyWith method
  UserAddressModel copyWith({
    int? id,
    String? label,
    String? city,
    String? street,
    String? landmark,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return UserAddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      city: city ?? this.city,
      street: street ?? this.street,
      landmark: landmark ?? this.landmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get fullAddress =>
      '$street, $city' + (landmark != null ? ', بالقرب من $landmark' : '');
}
