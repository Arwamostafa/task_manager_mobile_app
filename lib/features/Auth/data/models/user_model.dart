import 'package:task_manager/features/Auth/domain/entities/user.dart';

class UserModel {
  final String token;
  UserModel({required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String,
    );
  }

  User toEntity() {
    return User(token: token);
  }
}
