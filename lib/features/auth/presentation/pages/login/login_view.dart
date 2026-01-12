import 'package:ev_app/core/di/injection_container.dart';
import 'package:ev_app/features/auth/presentation/widgets/login_view_body.dart';
import 'package:ev_app/features/auth/presentation/view_model/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Login screen that provides authentication UI.
///
/// Uses dependency injection to provide AuthBloc.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Get AuthBloc from DI container
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const LoginViewBody(),
      ),
    );
  }
}
