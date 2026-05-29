// ignore_for_file: depend_on_referenced_packages
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

/// Thin wrapper around the Supabase Flutter SDK.
///
/// Call [init] once from main() before runApp(). If credentials are not
/// configured the call is a no-op and the app runs in offline mode.
///
/// Integration points (to be wired up as the feature repos are built):
///   - AuthRepository  → uses Supabase.instance.client.auth
///   - ProfileRepository → uses the `profiles` table
///   - WeightLogRepository → uses the `weight_logs` table
///   - FoodLogRepository   → uses the `food_logs` table
///
/// None of those repos are instantiated here; this service simply ensures the
/// SDK is ready before any of them try to access it.
class SupabaseService {
  const SupabaseService._();

  /// Initialises the Supabase client.
  ///
  /// Safe to call unconditionally from main() — when [SupabaseConfig.isConfigured]
  /// is false the method returns immediately without touching the SDK.
  static Future<void> init() async {
    if (!SupabaseConfig.isConfigured) {
      // Offline / unconfigured mode — skip SDK initialisation entirely.
      return;
    }

    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  /// [true] when credentials were provided at build time and the SDK was
  /// successfully initialised.  Feature code that requires a live backend
  /// must check this before calling [Supabase.instance].
  static bool get isReady => SupabaseConfig.isConfigured;

  /// Convenience accessor — only call after confirming [isReady].
  static SupabaseClient get client => Supabase.instance.client;
}
