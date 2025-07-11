import 'package:flutter_best_practices/managers/theme_manager.dart';
import 'package:flutter_best_practices/services/auth_service.dart';
import 'package:flutter_best_practices/services/connectivity_service.dart';
import 'package:flutter_best_practices/services/product_service.dart';
import 'package:flutter_best_practices/utils/navigation_guard.dart';

/// Register all singletons intended to be served in the provider here.
/// This allows accessing services dynamically anywhere in the application.
///
/// For example:
///
/// ```dart
/// final authService = Provider.get<AuthService>();
/// ```
Map<Type, dynamic Function()> providerInstances = {
  // Utilities
  ConnectivityService: () => ConnectivityService(),
  NavigationGuard: () => NavigationGuard(),
  ThemeManager: () => ThemeManager(),

  // Api services
  AuthService: () => AuthService(),
  ProductService: () => ProductService(),
};

Map<Type, dynamic Function()> lazyProviderInstances = {};
