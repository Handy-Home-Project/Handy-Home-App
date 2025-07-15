import 'dart:convert';

import 'package:handy_home_app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/shared_prefs_repository.dart';

class SharedPreferencesRepositoryImpl implements SharedPreferencesRepository {
  late final SharedPreferences _sharedPreferences;

  // KEY VALUES
  static const _userKey = "USER";

  @override
  Future<void> initSharedPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void saveUser(UserModel model) {
    _sharedPreferences.setString(_userKey, jsonEncode(model.toJson()));
  }

  @override
  UserModel? getUser() {
    final userStr = _sharedPreferences.getString(_userKey);
    if (userStr == null || userStr.isEmpty) return null;

    return UserModel.fromJson(jsonDecode(userStr));
  }
}
