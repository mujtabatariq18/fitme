import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/services/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load local persistence before the first frame so controllers init sync.
  final prefs = await SharedPreferences.getInstance();

  // TODO(phase-2): Supabase.initialize(url: ..., anonKey: ...) here.

  runApp(
    ProviderScope(
      overrides: [
        localStoreProvider.overrideWithValue(LocalStore(prefs)),
      ],
      child: const FitMeApp(),
    ),
  );
}
