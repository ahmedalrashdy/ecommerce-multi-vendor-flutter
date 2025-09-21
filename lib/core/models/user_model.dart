import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String email;
  final String? name;
  final String? bio;
  final String? profilePicture;
  final int id;
  final bool isVendor;
  final bool isSuperUser;
  final bool isDelivery;

  const UserModel({
    required this.email,
    this.name,
    this.bio,
    this.profilePicture,
    required this.id,
    required this.isDelivery,
    required this.isSuperUser,
    required this.isVendor,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],
      isVendor: json['is_vendor'] ?? false,
      isSuperUser: json['is_superuser'] ?? false,
      isDelivery: json['is_delivery'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'bio': bio,
      'profile_picture': profilePicture,
      'id': id,
      'is_delivery': isDelivery,
      'is_vendor': isVendor,
      'is_superuser': isSuperUser,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? bio,
    String? profilePicture,
    bool? isVendor,
    bool? isSuperUser,
    bool? isDelivery,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profilePicture: profilePicture ?? this.profilePicture,
      isDelivery: isDelivery ?? this.isDelivery,
      isVendor: isVendor ?? this.isVendor,
      isSuperUser: isSuperUser ?? this.isSuperUser,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        bio,
        profilePicture,
        isVendor,
        isSuperUser,
        isDelivery,
      ];
}
