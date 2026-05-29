import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/backend/supabase_service.dart';
import 'core/services/local_store.dart';
import 'features/notifications/application/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load local persistence before the first frame so controllers init sync.
  final prefs = await SharedPreferences.getInstance();

  // Backend (no-op unless SUPABASE_URL/ANON_KEY are provided via --dart-define).
  await SupabaseService.init();

  // Local notifications (reminders). Safe to await; permission asked later.
  try {
    await NotificationService.instance.init();
  } catch (_) {
    // Non-fatal: notifications unavailable on this platform/run.
  }

  runApp(
    ProviderScope(
      overrides: [
        localStoreProvider.overrideWithValue(LocalStore(prefs)),
      ],
      child: const FitMeApp(),
    ),
  );
}
