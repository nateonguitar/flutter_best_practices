import 'package:flutter/material.dart';
import 'package:flutter_best_practices/build_config.dart';
import 'package:flutter_best_practices/run_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BuildConfig.instance = BuildConfig(
    apiUrl: 'https://example.com/api/',
    environment: Environment.production,
  );
  await runApplication();
}
