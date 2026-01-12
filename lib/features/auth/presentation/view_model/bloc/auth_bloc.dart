import 'package:ev_app/core/errors/failures.dart';
import 'package:ev_app/core/utils/app_logger.dart';
import 'package:ev_app/features/auth/data/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Manages authentication state and handles user sign-in operations.
///
/// This BLoC handles both email/password and Google OAuth authentication,
/// emitting appropriate states during the authentication flow.
///
/// Events:
/// - [EmailSignInRequested]: Triggered when user attempts email sign-in
/// - [GoogleSignInRequested]: Triggered when user attempts Google sign-in
///
/// States:
/// - [AuthInitial]: Initial state before any authentication
/// - [AuthLoading]: Authentication in progress
/// - [AuthSuccess]: User successfully authenticated
/// - [AuthError]: Authentication failed with error message
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo repo;

  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<EmailSignInRequested>(_onEmailSignIn);
  }

  /// Handles Google sign-in authentication flow.
  ///
  /// Emits [AuthLoading] while processing, then either [AuthSuccess]
  /// with user credentials or [AuthError] if authentication fails.
  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('Google sign-in requested');
    emit(AuthLoading());

    final result = await repo.loginWithGoogle();

    result.fold(
      (failure) {
        AppLogger.warning('Google sign-in failed: ${failure.message}');
        emit(AuthError(errorMessage: _getErrorMessage(failure)));
      },
      (userCredential) {
        AppLogger.info('Google sign-in successful');
        emit(AuthSuccess(userCred: userCredential));
      },
    );
  }

  /// Handles email/password sign-in authentication flow.
  ///
  /// Emits [AuthLoading] while processing, then either [AuthSuccess]
  /// with user credentials or [AuthError] if authentication fails.
  Future<void> _onEmailSignIn(
    EmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('Email sign-in requested for: ${event.emailAddress}');
    emit(AuthLoading());

    final result = await repo.signInWithEmail(
      event.emailAddress,
      event.password,
    );

    result.fold(
      (failure) {
        AppLogger.warning('Email sign-in failed: ${failure.message}');
        emit(AuthError(errorMessage: _getErrorMessage(failure)));
      },
      (userCredential) {
        AppLogger.info('Email sign-in successful');
        emit(AuthSuccess(userCred: userCredential));
      },
    );
  }

  /// Converts a [Failure] to a user-friendly error message.
  ///
  /// Provides specific messages for different failure types.
  String _getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    } else if (failure is AuthFailure) {
      return failure.message;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
