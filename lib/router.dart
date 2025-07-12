import 'package:flutter/material.dart';
import 'package:flutter_best_practices/pages/home_page.dart';
import 'package:flutter_best_practices/pages/landing_page.dart';
import 'package:flutter_best_practices/pages/login_page.dart';
import 'package:flutter_best_practices/pages/settings_page.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/services/auth_service.dart';
import 'package:flutter_best_practices/widgets/navigation_widget.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  landing,
  login,
  settings,
}

// Lazy load the router to avoid managers being null during initialization.

// ignore: unnecessary_late
late final router = GoRouter(
  initialLocation: '/',
  refreshListenable: Listenable.merge([
    Provider.get<AuthService>().authToken,
    Provider.get<AuthService>().authTokenValidating,
  ]),

  // Note: "redirect" is only called when the refreshListenable notifies,
  // which happens when auth or landing animation state changes.
  redirect: (context, state) {
    final authService = Provider.get<AuthService>();
    final authToken = authService.authToken.value;
    final authTokenValidating = authService.authTokenValidating.value;

    final onLoginPage = state.matchedLocation == '/${AppRoute.login.name}';
    final onLandingPage = state.matchedLocation == '/';

    if (onLandingPage) {
      if (authTokenValidating) {
        // Working on validating the auth token, keep user on landing page.
        return '/';
      }
      if (authToken == null) {
        return '/${AppRoute.login.name}';
      }
      // Not validating and token is set
      return '/${AppRoute.home.name}';
    }

    if (onLoginPage) {
      if (authTokenValidating) {
        // Working on validating the auth token, keep user on landing page.
        return '/${AppRoute.login.name}';
      }
      if (authToken == null) {
        return '/${AppRoute.login.name}';
      }
      // Not validating and token is set
      return '/${AppRoute.home.name}';
    }

    if (authToken == null) {
      return '/${AppRoute.login.name}';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.landing.name,
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/${AppRoute.login.name}',
      name: AppRoute.login.name,
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return NavigationWidget(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/${AppRoute.home.name}',
          name: AppRoute.home.name,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/${AppRoute.settings.name}',
          name: AppRoute.settings.name,
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Route not found: ${state.matchedLocation}',
      ),
    ),
  ),
);
