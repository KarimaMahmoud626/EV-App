/// Centralized route name constants for the application.
///
/// This class provides type-safe route names for navigation throughout the app.
/// Using constants prevents typos and makes refactoring easier.
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Authentication Routes
  static const String onboarding = '/';
  static const String login = '/login';

  // Main App Routes
  static const String main = '/main';

  // Feature Routes (used with nested navigation)
  static const String stations = '/stations';
  static const String batteryStatus = '/battery-status';
  static const String history = '/history';
  static const String settings = '/settings';

  // Detail Routes
  static const String stationDetails = '/station-details';
  static const String batteryDetails = '/battery-details';

  /// Returns the initial route based on authentication state
  static String get initialRoute => onboarding;
}
