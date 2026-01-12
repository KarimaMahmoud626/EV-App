import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized configuration for environment variables.
///
/// Provides type-safe access to environment variables loaded from .env file.
/// All sensitive data (API keys, secrets) should be accessed through this class.
class EnvConfig {
  /// API key for EV charger station service.
  ///
  /// Get your API key from: https://api-ninjas.com/
  static String get evChargerApiKey => dotenv.env['EV_CHARGER_API_KEY'] ?? '';

  /// Validates that all required environment variables are present.
  ///
  /// Throws an exception if any required variable is missing.
  static void validate() {
    if (evChargerApiKey.isEmpty) {
      throw Exception(
        'EV_CHARGER_API_KEY is not set in .env file. '
        'Please create a .env file with your API key.',
      );
    }
  }
}
