import 'package:ev_app/core/routes/app_routes.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';

/// Navigation helper class for type-safe navigation throughout the app.
///
/// This class provides convenient methods for navigating between screens
/// with proper type safety and error handling.
///
/// Usage:
/// ```dart
/// NavigationHelper.toMain(context, user: userModel);
/// NavigationHelper.toLogin(context, replace: true);
/// ```
class NavigationHelper {
  // Private constructor to prevent instantiation
  NavigationHelper._();

  /// Navigates to the onboarding screen.
  static Future<void> toOnboarding(
    BuildContext context, {
    bool replace = false,
  }) {
    if (replace) {
      return Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
    return Navigator.pushNamed(context, AppRoutes.onboarding);
  }

  /// Navigates to the login screen.
  static Future<void> toLogin(BuildContext context, {bool replace = false}) {
    if (replace) {
      return Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
    return Navigator.pushNamed(context, AppRoutes.login);
  }

  /// Navigates to the main app screen (navigation shell).
  ///
  /// Requires [user] data to be passed as an argument.
  /// By default, replaces the current route (used after login).
  static Future<void> toMain(
    BuildContext context, {
    required UserModel user,
    bool replace = true,
  }) {
    if (replace) {
      return Navigator.pushReplacementNamed(
        context,
        AppRoutes.main,
        arguments: user,
      );
    }
    return Navigator.pushNamed(context, AppRoutes.main, arguments: user);
  }

  /// Pops the current route off the navigator stack.
  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  /// Pops all routes until the predicate returns true.
  static void popUntil(BuildContext context, RoutePredicate predicate) {
    Navigator.popUntil(context, predicate);
  }

  /// Pops all routes and navigates to the specified route.
  static Future<void> popAndPushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.popAndPushNamed(context, routeName, arguments: arguments);
  }

  /// Removes all previous routes and navigates to the specified route.
  static Future<void> pushNamedAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
    RoutePredicate? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Checks if the navigator can pop.
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Pops the navigator if possible, otherwise does nothing.
  static void maybePop(BuildContext context, [dynamic result]) {
    if (canPop(context)) {
      pop(context, result);
    }
  }
}
