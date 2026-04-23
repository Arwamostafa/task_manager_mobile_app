import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences prefs;
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  AuthLocalDataSource(this.prefs);

  Future<void> cacheToken(String token) async {
    await prefs.setString(_tokenKey, token);
  }

  String? getToken() => prefs.getString(_tokenKey);

  Future<void> deleteToken() async {
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  Future<void> saveUserId(int userId) async {
    await prefs.setInt(_userIdKey, userId);
  }

  int? getUserId() => prefs.getInt(_userIdKey);
}
