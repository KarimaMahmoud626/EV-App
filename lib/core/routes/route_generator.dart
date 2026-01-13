import 'package:ev_app/core/routes/app_routes.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/auth/presentation/pages/login/login_view.dart';
import 'package:ev_app/features/onboarding/presentation/onboarding_view.dart';
import 'package:ev_app/features/settings/presentation/pages/settings_view.dart';
import 'package:ev_app/core/navigation/navigation_shell.dart';
import 'package:flutter/material.dart';

/// Generates routes for the application.
///
/// This class handles all route generation and provides a centralized place
/// for navigation logic. It supports both simple and complex navigation patterns.
class RouteGenerator {
  // Private constructor to prevent instantiation
  RouteGenerator._();

  /// Generates a route based on the provided [RouteSettings].
  ///
  /// Returns a [MaterialPageRoute] for the requested route, or an error page
  /// if the route is not found.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments if any
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.onboarding:
        return _buildRoute(const OnboardingView(), settings: settings);

      case AppRoutes.login:
        return _buildRoute(const LoginView(), settings: settings);

      case AppRoutes.main:
        // Main navigation shell requires user data
        if (args is UserModel) {
          return _buildRoute(NavigationShell(user: args), settings: settings);
        }
        return _errorRoute(settings);

      case AppRoutes.settings:
        // Settings screen requires user data
        if (args is UserModel) {
          return _buildRoute(SettingsView(user: args), settings: settings);
        }
        return _errorRoute(settings);

      default:
        return _errorRoute(settings);
    }
  }

  /// Builds a [MaterialPageRoute] with the given [page] and [settings].
  static MaterialPageRoute<dynamic> _buildRoute(
    Widget page, {
    required RouteSettings settings,
  }) {
    return MaterialPageRoute<dynamic>(
      builder: (context) => page,
      settings: settings,
    );
  }

  /// Returns an error route when the requested route is not found.
  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder:
          (context) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Route not found: ${settings.name}',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
      settings: settings,
    );
  }
}
