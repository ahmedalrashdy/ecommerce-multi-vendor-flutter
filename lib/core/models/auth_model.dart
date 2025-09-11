import 'user_model.dart';

class AuthModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthModel.fromMap(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['access_token'] ?? json['access'],
      refreshToken: json['refresh_token'] ?? json['refresh'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
    };
  }

  AuthModel copyWith({
    String? accessToken,
    String? refreshToken,
    UserModel? user,
  }) {
    return AuthModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }
}
