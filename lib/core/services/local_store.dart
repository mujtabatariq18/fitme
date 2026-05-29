import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Injected in main() after SharedPreferences loads. Read synchronously
/// everywhere via `ref.read(localStoreProvider)`.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('localStoreProvider must be overridden'),
);

/// Thin typed wrapper around SharedPreferences. Keeps key strings in one place.
class LocalStore {
  LocalStore(this._prefs);
  final SharedPreferences _prefs;

  static const _kProfile = 'fitme.profile.v1';
  static const _kAiConfig = 'fitme.ai_config.v1';
  static const _kThemeMode = 'fitme.theme_mode';
  static const _kAccounts = 'fitme.accounts.v1';
  static const _kSession = 'fitme.session.v1';
  static const _kFoodLog = 'fitme.food_log.v1';
  static const _kWeightLog = 'fitme.weight_log.v1';

  String? getProfile() => _prefs.getString(_kProfile);
  Future<void> setProfile(String json) => _prefs.setString(_kProfile, json);

  String? getAiConfig() => _prefs.getString(_kAiConfig);
  Future<void> setAiConfig(String json) => _prefs.setString(_kAiConfig, json);

  String? getThemeMode() => _prefs.getString(_kThemeMode);
  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_kThemeMode, mode);

  // Auth: accounts registry (incl. credentials) + current session.
  String? getAccounts() => _prefs.getString(_kAccounts);
  Future<void> setAccounts(String json) => _prefs.setString(_kAccounts, json);
  String? getSession() => _prefs.getString(_kSession);
  Future<void> setSession(String userId) => _prefs.setString(_kSession, userId);
  Future<void> clearSession() => _prefs.remove(_kSession);

  // Logs.
  String? getFoodLog() => _prefs.getString(_kFoodLog);
  Future<void> setFoodLog(String json) => _prefs.setString(_kFoodLog, json);
  String? getWeightLog() => _prefs.getString(_kWeightLog);
  Future<void> setWeightLog(String json) => _prefs.setString(_kWeightLog, json);

  Future<void> clear() => _prefs.clear();
}
