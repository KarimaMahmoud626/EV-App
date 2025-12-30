part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GoogleSignInRequested extends AuthEvent {}

class EmailSignInRequested extends AuthEvent {
  final String emailAddress;
  final String password;

  const EmailSignInRequested({
    required this.emailAddress,
    required this.password,
  });

  @override
  List<Object> get props => [emailAddress, password];
}
