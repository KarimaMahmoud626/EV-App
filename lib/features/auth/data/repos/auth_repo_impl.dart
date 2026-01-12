import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ev_app/core/errors/failures.dart';
import 'package:ev_app/core/utils/app_logger.dart';
import 'package:ev_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/auth/data/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Implementation of [AuthRepo] that handles authentication operations.
///
/// Manages Google OAuth and email/password authentication, including
/// user data persistence to Firestore.
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource dataSource;

  AuthRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserCredential>> loginWithGoogle() async {
    try {
      AppLogger.info('Starting Google sign-in flow');

      final userCredential = await dataSource.signInWithGoogle();

      // Validate user data
      final user = userCredential.user;
      if (user == null || user.email == null) {
        AppLogger.error('Google sign-in returned null user or email');
        return const Left(
          AuthFailure(
            'Failed to get user information from Google',
            code: 'null-user-data',
          ),
        );
      }

      // Save user data to Firestore
      await dataSource.saveUserData(
        UserModel(
          email: user.email!,
          name: user.displayName,
          photoUrl: user.photoURL,
        ),
      );

      AppLogger.info('Google sign-in successful for user: ${user.email}');
      return Right(userCredential);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error(
        'Firebase auth error during Google sign-in',
        e,
        stackTrace,
      );

      switch (e.code) {
        case 'sign_in_canceled':
          return const Left(
            AuthFailure('Sign-in was canceled', code: 'sign-in-canceled'),
          );
        case 'network-request-failed':
          return const Left(
            NetworkFailure(
              'Network error. Please check your internet connection.',
            ),
          );
        case 'account-exists-with-different-credential':
          return const Left(
            AuthFailure(
              'An account already exists with the same email but different sign-in method',
              code: 'account-exists',
            ),
          );
        default:
          return Left(
            AuthFailure(e.message ?? 'Google sign-in failed', code: e.code),
          );
      }
    } on SocketException catch (e, stackTrace) {
      AppLogger.error('Network error during Google sign-in', e, stackTrace);
      return const Left(
        NetworkFailure('No internet connection. Please check your network.'),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during Google sign-in', e, stackTrace);
      return Left(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      AppLogger.info('Attempting email sign-in for: $email');

      // Try to create new account
      final userCredential = await dataSource.createWithEmail(email, password);

      // Validate user data
      final user = userCredential.user;
      if (user == null || user.email == null) {
        AppLogger.error('Email sign-in returned null user or email');
        return const Left(
          AuthFailure('Failed to get user information', code: 'null-user-data'),
        );
      }

      // Save user data to Firestore
      await dataSource.saveUserData(
        UserModel(
          email: user.email!,
          name: user.displayName,
          photoUrl: user.photoURL,
        ),
      );

      AppLogger.info('Account created successfully for: $email');
      return Right(userCredential);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.warning('Firebase auth error during email sign-in', e);

      switch (e.code) {
        case 'weak-password':
          return const Left(
            AuthFailure(
              'Password is too weak. Please use a stronger password with at least 6 characters.',
              code: 'weak-password',
            ),
          );
        case 'email-already-in-use':
          // Account exists, try to sign in instead
          AppLogger.info('Account exists for $email, attempting sign-in');
          try {
            final signInCredential = await dataSource.signInWithEmail(
              email,
              password,
            );

            final user = signInCredential.user;
            if (user == null || user.email == null) {
              return const Left(
                AuthFailure(
                  'Failed to get user information',
                  code: 'null-user-data',
                ),
              );
            }

            // Update user data in Firestore
            await dataSource.saveUserData(
              UserModel(
                email: user.email!,
                name: user.displayName,
                photoUrl: user.photoURL,
              ),
            );

            AppLogger.info('Sign-in successful for existing user: $email');
            return Right(signInCredential);
          } on FirebaseAuthException catch (signInError) {
            if (signInError.code == 'wrong-password') {
              return const Left(
                AuthFailure(
                  'An account with this email already exists. Please sign in with the correct password.',
                  code: 'email-already-in-use',
                ),
              );
            }
            return Left(
              AuthFailure(
                signInError.message ?? 'Authentication failed',
                code: signInError.code,
              ),
            );
          }
        case 'invalid-email':
          return const Left(
            AuthFailure('Invalid email address format.', code: 'invalid-email'),
          );
        case 'user-not-found':
          return const Left(
            AuthFailure(
              'No account found with this email.',
              code: 'user-not-found',
            ),
          );
        case 'wrong-password':
          return const Left(
            AuthFailure(
              'Incorrect password. Please try again.',
              code: 'wrong-password',
            ),
          );
        case 'network-request-failed':
          return const Left(
            NetworkFailure(
              'Network error. Please check your internet connection.',
            ),
          );
        default:
          return Left(
            AuthFailure(e.message ?? 'Authentication failed', code: e.code),
          );
      }
    } on SocketException catch (e, stackTrace) {
      AppLogger.error('Network error during email sign-in', e, stackTrace);
      return const Left(
        NetworkFailure('No internet connection. Please check your network.'),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during email sign-in', e, stackTrace);
      return Left(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
