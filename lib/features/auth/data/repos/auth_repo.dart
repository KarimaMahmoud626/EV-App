import 'package:dartz/dartz.dart';
import 'package:ev_app/core/errors/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Abstract repository for authentication operations.
///
/// Defines the contract for authentication-related operations.
/// Returns Either<Failure, T> for functional error handling.
abstract class AuthRepo {
  /// Sign in with Google OAuth.
  ///
  /// Returns [UserCredential] on success or [AuthFailure]/[NetworkFailure] on error.
  Future<Either<Failure, UserCredential>> loginWithGoogle();

  /// Sign in or create account with email and password.
  ///
  /// Returns [UserCredential] on success or [AuthFailure]/[NetworkFailure] on error.
  Future<Either<Failure, UserCredential>> signInWithEmail(
    String email,
    String password,
  );
}
