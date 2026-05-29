/// Compile-time Supabase configuration.
///
/// Credentials are injected via --dart-define at build time:
///   flutter run --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///               --dart-define=SUPABASE_ANON_KEY=your-anon-key
///
/// When neither variable is set (e.g. during offline/CI runs) [isConfigured]
/// returns false and the app operates entirely in local/offline mode.
class SupabaseConfig {
  const SupabaseConfig._();

  /// Supabase project URL, injected at build time.
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  /// Supabase anonymous (public) API key, injected at build time.
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// Returns [true] only when both [url] and [anonKey] are non-empty.
  /// All Supabase-dependent code must gate behind this flag so the app
  /// remains fully functional without backend credentials.
  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
