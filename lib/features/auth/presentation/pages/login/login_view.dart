import 'package:ev_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:ev_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:ev_app/features/auth/presentation/pages/login/widgets/login_view_body.dart';
import 'package:ev_app/features/auth/presentation/viewModel/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AuthBloc(
            repo: AuthRepoImpl(
              dataSource: AuthRemoteDataSourceImpl(
                FirebaseAuth.instance,
                GoogleSignIn(),
              ),
            ),
          ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: LoginViewBody(),
      ),
    );
  }
}
