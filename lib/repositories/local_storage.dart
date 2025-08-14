import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage helper using SharedPreferences.
/// Usage:
/// await LocalStorage.init();
/// await LocalStorage.saveString('key','value');
/// final v = await LocalStorage.getString('key');
class LocalStorage {
  static SharedPreferences? _prefs;

  static const String _keyPersonal = 'personal';
  static const String _keyAddress = 'address';
  static const String _keyFamily = 'family';
  static const String _keyNominee = 'nominee';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  /// Initialize the SharedPreferences instance (recommended at app start).
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveString(String key, String value) async {
    await init();
    await _prefs!.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    await init();
    return _prefs!.getString(key);
  }

  static Future<void> saveJson(String key, Map<String, dynamic> json) async {
    await saveString(key, jsonEncode(json));
  }

  static Future<Map<String, dynamic>?> getJson(String key) async {
    final s = await getString(key);
    if (s == null) return null;
    try {
      final decoded = jsonDecode(s);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  // Convenience methods for domain keys:

  static Future<void> savePersonal(Map<String, dynamic> json) async => saveJson(_keyPersonal, json);
  static Future<Map<String, dynamic>?> getPersonal() async => getJson(_keyPersonal);

  static Future<void> saveAddress(Map<String, dynamic> json) async => saveJson(_keyAddress, json);
  static Future<Map<String, dynamic>?> getAddress() async => getJson(_keyAddress);

  static Future<void> saveFamily(Map<String, dynamic> json) async => saveJson(_keyFamily, json);
  static Future<Map<String, dynamic>?> getFamily() async => getJson(_keyFamily);

  static Future<void> saveNominee(Map<String, dynamic> json) async => saveJson(_keyNominee, json);
  static Future<Map<String, dynamic>?> getNominee() async => getJson(_keyNominee);

  static Future<void> saveOnboardingCompleted(bool value) async {
    await init();
    await _prefs!.setBool(_keyOnboardingCompleted, value);
  }

  static Future<bool> getOnboardingCompleted() async {
    await init();
    return _prefs!.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Clear all stored onboarding-related keys (helpful for testing).
  static Future<void> clearAll() async {
    await init();
    await _prefs!.remove(_keyPersonal);
    await _prefs!.remove(_keyAddress);
    await _prefs!.remove(_keyFamily);
    await _prefs!.remove(_keyNominee);
    await _prefs!.remove(_keyOnboardingCompleted);
  }
}
