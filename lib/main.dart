import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'bootstrap/dependencies.dart';
import 'core/config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final backend = await createBackend(Env.backend);
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [...platformOverrides(prefs), ...backendOverrides(backend)],
      child: const DocsBuddyApp(),
    ),
  );
}
