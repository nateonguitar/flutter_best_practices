import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_best_practices/app.dart';
import 'package:flutter_best_practices/build_config.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/provider_instances.dart';
import 'package:flutter_best_practices/services/api_service.dart';

Future<void> runApplication({
  Map<Type, dynamic Function()> providerOverrides = const {},
  Map<Type, dynamic Function()> lazyProviderInstances = const {},
}) async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  ApiService.dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      baseUrl: BuildConfig.instance.apiUrl,
    ),
  );

  // Allow self-signed certificates in development
  if (BuildConfig.instance.environment == Environment.development) {
    (ApiService.dio.httpClientAdapter as dynamic).onHttpClientCreate =
        (
          HttpClient client,
        ) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
  }

  Provider.initialize(
    instances: providerInstances,
    lazyInstances: lazyProviderInstances,
    overrides: providerOverrides,
    lazyOverrides: lazyProviderInstances,
  );
  runApp(const App());
}
