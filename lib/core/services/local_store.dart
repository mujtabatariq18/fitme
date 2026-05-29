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

  String? getProfile() => _prefs.getString(_kProfile);
  Future<void> setProfile(String json) => _prefs.setString(_kProfile, json);

  String? getAiConfig() => _prefs.getString(_kAiConfig);
  Future<void> setAiConfig(String json) => _prefs.setString(_kAiConfig, json);

  String? getThemeMode() => _prefs.getString(_kThemeMode);
  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_kThemeMode, mode);

  Future<void> clear() => _prefs.clear();
}
