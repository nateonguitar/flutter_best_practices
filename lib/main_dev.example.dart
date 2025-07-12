// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_best_practices/build_config.dart';
import 'package:flutter_best_practices/mock_data.dart';
import 'package:flutter_best_practices/run_app.dart';
import 'package:flutter_best_practices/services/auth_service.dart';
import 'package:flutter_best_practices/services/connectivity_service.dart';
import 'package:flutter_best_practices/services/product_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String apiUrl;
  if (Platform.isAndroid) {
    // Android emulator localhost of the host computer magic ip = 10.0.2.2
    apiUrl = 'http://10.0.2.2:5104/api/';
    // apiUrl = 'https://10.0.2.2:7006/api/';
  } else if (Platform.isWindows) {
    apiUrl = 'http://localhost:5104/api/';
    // apiUrl = 'https://localhost:7006/api/';
  } else {
    apiUrl = 'http://localhost:5104/api/';
    // apiUrl = 'https://localhost:7006/api/';
  }
  BuildConfig.instance = BuildConfig(
    // mockNetworkLatencyDuration: const Duration(seconds: 1),
    apiUrl: apiUrl,
    loginAutofill: LoginAutofill(
      username: 'username1',
      password: r'Test1234$',
    ),
    environment: Environment.development,
  );
  MockData.generate();
  await runApplication(
    providerOverrides: {
      // ConnectivityService: () => MockConnectivityService(connected: false),
      AuthService: () => MockAuthService(
        validateAuthTokenSuccess: false,
      ),
      ProductService: () => MockProductService(),
    },
  );
}
