import 'package:ev_app/features/auth/data/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo repo;

  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<EmailSignInRequested>(_onEmailSignIn);
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await repo.loginWithGoogle();

    result.fold(
      (e) => emit(AuthError(errorMessage: e.toString())),
      (user) => emit(AuthSuccess(userCred: user)),
    );
  }

  Future<void> _onEmailSignIn(
    EmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await repo.signInWithEmail(
      event.emailAddress,
      event.password,
    );

    result.fold(
      (e) => emit(AuthError(errorMessage: e.toString())),
      (user) => emit(AuthSuccess(userCred: user)),
    );
  }
}
