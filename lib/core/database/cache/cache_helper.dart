import 'package:cura_watch/core/api/end_points.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> saveUserData({
    required String token,
    required String id,
    required String role,
    required String fullName,
  }) async {
    if (await saveData(key: APIKeys.fullName, value: fullName) &&
        await saveData(key: APIKeys.token, value: token) &&
        await saveData(key: APIKeys.id, value: id) &&
        await saveData(key: APIKeys.role, value: role)) {
      return true;
    }
    return false;
  }

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    } else {
      debugPrint(value.runtimeType.toString());
      throw ('Unsupported value type');
    }
  }

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

  Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }
}
