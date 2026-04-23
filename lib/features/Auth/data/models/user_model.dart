import 'package:task_manager/features/Auth/domain/entities/user.dart';

class UserModel {
  final String token;
  final int? userId;

  UserModel({required this.token, this.userId});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return UserModel(
      token: (json['accessToken'] ?? json['token'] ?? '') as String,
      userId: user?['id'] as int?,
    );
  }

  User toEntity() {
    return User(token: token);
  }
}
