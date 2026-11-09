import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides the local persistence boundary used by feature controllers.
final Provider<LocalAppRepository> localAppRepositoryProvider = Provider(
  (ref) => LocalAppRepository(),
);

/// Reads and writes feature values in SharedPreferences.
class LocalAppRepository {
  /// SharedPreferences instance used by local persistence operations.
  Future<SharedPreferences> get preferences => SharedPreferences.getInstance();

  /// Decodes a stored JSON list; returns null when the key is absent.
  Future<List<Map<String, dynamic>>?> readList(String key) async {
    final value = (await preferences).getString(key);
    return value == null
        ? null
        : (jsonDecode(value) as List).cast<Map<String, dynamic>>();
  }

  /// Encodes and stores a list of JSON objects under the supplied key.
  Future<void> writeList(String key, List<Map<String, dynamic>> values) async {
    await (await preferences).setString(key, jsonEncode(values));
  }

  /// Stores an integer under the supplied key.
  Future<void> writeInt(String key, int value) async {
    await (await preferences).setInt(key, value);
  }

  /// Stores a boolean preference under the supplied key.
  Future<void> writeBool(String key, {required bool value}) async {
    await (await preferences).setBool(key, value);
  }

  /// Stores a string, or removes its key when the value is null.
  Future<void> writeString(String key, String? value) async {
    final prefs = await preferences;
    if (value == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, value);
    }
  }
}
