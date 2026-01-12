import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// Failures represent errors that occur in the domain/data layer
/// and are returned to the presentation layer for handling.
abstract class Failure extends Equatable {
  /// Human-readable error message
  final String message;

  /// Optional error code for specific error types
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() =>
      code != null
          ? '$runtimeType: $message (code: $code)'
          : '$runtimeType: $message';
}

/// Failure that occurs when there are network connectivity issues.
///
/// Examples: No internet connection, timeout, connection refused
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

/// Failure that occurs when the server returns an error response.
///
/// Examples: 500 Internal Server Error, 404 Not Found, 401 Unauthorized
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(String message, {String? code, this.statusCode})
    : super(message, code: code);

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Failure that occurs during authentication operations.
///
/// Examples: Wrong password, invalid email, user not found
class AuthFailure extends Failure {
  const AuthFailure(String message, {String? code})
    : super(message, code: code);
}

/// Failure that occurs when accessing device location.
///
/// Examples: GPS disabled, location permission denied
class LocationFailure extends Failure {
  const LocationFailure(String message) : super(message);
}

/// Failure that occurs when accessing local cache/storage.
///
/// Examples: Failed to save data, failed to read data
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// Failure that occurs during data parsing or validation.
///
/// Examples: Invalid JSON format, missing required fields
class ParsingFailure extends Failure {
  const ParsingFailure(String message) : super(message);
}
