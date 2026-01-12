/// Base exception class for data layer errors.
///
/// Exceptions are thrown in the data layer and caught in repositories
/// where they are converted to Failures.
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Exception thrown when a server error occurs.
///
/// This includes HTTP errors like 500, 404, 401, etc.
class ServerException extends AppException {
  final int? statusCode;

  ServerException(super.message, {this.statusCode});

  @override
  String toString() =>
      statusCode != null
          ? 'ServerException: $message (status: $statusCode)'
          : 'ServerException: $message';
}

/// Exception thrown when a network error occurs.
///
/// This includes connection timeouts, no internet, etc.
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Exception thrown when location services fail.
///
/// This includes permission denied, GPS disabled, etc.
class LocationException extends AppException {
  LocationException(super.message);
}

/// Exception thrown when cache operations fail.
///
/// This includes read/write failures to local storage.
class CacheException extends AppException {
  CacheException(super.message);
}

/// Exception thrown when data parsing fails.
///
/// This includes JSON parsing errors, invalid data formats, etc.
class ParsingException extends AppException {
  ParsingException(super.message);
}
