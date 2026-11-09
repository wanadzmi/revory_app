import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localAppRepositoryProvider = Provider((ref) => LocalAppRepository());

class LocalAppRepository {
  Future<SharedPreferences> get preferences => SharedPreferences.getInstance();
  Future<List<Map<String, dynamic>>?> readList(String key) async {
    final value = (await preferences).getString(key);
    return value == null
        ? null
        : (jsonDecode(value) as List).cast<Map<String, dynamic>>();
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> values) async {
    await (await preferences).setString(key, jsonEncode(values));
  }

  Future<void> writeInt(String key, int value) async {
    await (await preferences).setInt(key, value);
  }

  Future<void> writeBool(String key, bool value) async {
    await (await preferences).setBool(key, value);
  }

  Future<void> writeString(String key, String? value) async {
    final prefs = await preferences;
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }
}
