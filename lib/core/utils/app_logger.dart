import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging utility for the application.
///
/// Provides different log levels (debug, info, warning, error) and
/// automatically disables debug/info logs in production builds.
///
/// Usage:
/// ```dart
/// AppLogger.debug('User tapped login button');
/// AppLogger.info('Authentication successful');
/// AppLogger.warning('Slow network detected');
/// AppLogger.error('Failed to load data', error, stackTrace);
/// ```
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to be displayed
      errorMethodCount: 5, // Number of method calls for errors
      lineLength: 80, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false, // Should each log print contain a timestamp
    ),
    level: kDebugMode ? Level.debug : Level.warning,
  );

  /// Log debug information.
  ///
  /// Only visible in debug builds. Use for detailed debugging information.
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log informational messages.
  ///
  /// Only visible in debug builds. Use for general information about app flow.
  static void info(String message, [dynamic error]) {
    if (kDebugMode) {
      _logger.i(message, error: error);
    }
  }

  /// Log warning messages.
  ///
  /// Visible in all builds. Use for potentially harmful situations.
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error messages.
  ///
  /// Visible in all builds. Use for error events that might still allow
  /// the app to continue running.
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error messages.
  ///
  /// Visible in all builds. Use for very severe error events that will
  /// presumably lead the app to abort.
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
