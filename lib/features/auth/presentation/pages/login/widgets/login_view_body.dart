import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/custom_buttons.dart';
import 'package:ev_app/core/widgets/custom_line.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/auth/presentation/pages/login/widgets/login_form_item.dart';
import 'package:ev_app/features/auth/presentation/manager/bloc/auth_bloc.dart';
import 'package:ev_app/features/nav_bar/presentation/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final colors = Theme.of(context).colorScheme;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => CustomNavigationBar(
                    user: UserModel(
                      name: state.userCred.user!.displayName,
                      email: state.userCred.user!.email!,
                    ),
                  ),
            ),
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpace(7),
                Text(
                  'Welcome \n to EV Logger🔋',
                  style: TextStyle(
                    color: colors.onBackground,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Enter your credential to access your\n battery insights account',
                  style: TextStyle(
                    color: colors.onBackground,
                    fontSize: 16,
                    fontWeight: FontWeight.w100,
                  ),
                  textAlign: TextAlign.left,
                ),
                VerticalSpace(3),
                IgnorePointer(
                  ignoring: isLoading,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LoginFormItem(
                          text: 'Full Name',
                          icon: Icons.person,
                          keyboardType: TextInputType.name,
                          controller: nameController,
                        ),
                        VerticalSpace(2.5),
                        LoginFormItem(
                          text: 'Email Address',
                          icon: Icons.email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (!value.contains('@')) return 'Invalid email';
                            return null;
                          },
                        ),
                        VerticalSpace(2.5),
                        LoginFormItem(
                          text: 'Password',
                          controller: passwordController,
                          icon: Icons.lock_rounded,
                          suffixIcon: Icons.visibility_outlined,
                          keyboardType: TextInputType.visiblePassword,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Required Field'
                                      : null,
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalSpace(3),
                CustomLoginButton(
                  isLoading: isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context.read<AuthBloc>().add(
                        EmailSignInRequested(
                          emailAddress: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        ),
                      );
                    }
                  },
                ),
                VerticalSpace(1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomLine(),
                    Text(' Or ', style: TextStyle(fontSize: 16)),
                    CustomLine(),
                  ],
                ),
                VerticalSpace(1.5),
                CustomLoginWithButton(
                  isLoading: isLoading,
                  text: 'Google',
                  imagePath: 'assets/icons/google_icon.png',
                  onTap: () {
                    context.read<AuthBloc>().add(GoogleSignInRequested());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
