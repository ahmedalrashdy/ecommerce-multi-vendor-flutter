import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? invitationId;
  final String email;
  final String? name;
  final String? bio;
  final String? profile;
  final String? profileBg;
  final String? profile_picture;
  final String? cover_photo;
  final int id;
  final bool isProfileComplete;

  const UserModel({
    required this.email,
    this.name,
    this.bio,
    this.profile,
    this.profileBg,
    required this.id,
    this.profile_picture,
    this.cover_photo,
    this.invitationId,
    required this.isProfileComplete,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      profile_picture: json['profile'],
      cover_photo: json['profile_bg'],
      invitationId: json['invitation_id'],
      isProfileComplete: json['is_profile_complete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'bio': bio,
      'profile': profile,
      'profile_bg': profileBg,
      'id': id,
      'is_profile_complete': isProfileComplete,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isStaff,
    bool? isActive,
    bool? verified,
    String? bio,
    String? profile,
    String? profileBg,
    bool? isProfileComplete,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profile_picture: profile ?? this.profile_picture,
      cover_photo: profileBg ?? this.cover_photo,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        id,
        bio,
        profile_picture,
        cover_photo,
        id,
        isProfileComplete,
      ];
}
