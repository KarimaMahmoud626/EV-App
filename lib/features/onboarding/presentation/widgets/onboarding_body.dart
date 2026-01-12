import 'package:ev_app/core/utils/navigation_helper.dart';
import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/custom_buttons.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/auth/presentation/view_model/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final colors = Theme.of(context).colorScheme;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Use NavigationHelper for type-safe navigation
          NavigationHelper.toMain(
            context,
            user: UserModel(
              name: state.userCred.user!.displayName,
              email: state.userCred.user!.email!,
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
        return SafeArea(
          child: Column(
            children: [
              VerticalSpace(3),
              Center(
                child: SizedBox(
                  width: SizeConfig.screenWidth! * 0.85,
                  child: Image.asset('assets/images/onboarding.png'),
                ),
              ),
              Text(
                'Control Your\n  EV Easily',
                style: TextStyle(
                  fontSize: 42,
                  color: colors.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage battery levels, monitor usage and health, and find charging stations in one app',
                style: TextStyle(
                  color: colors.onBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                ),
                textAlign: TextAlign.center,
              ),
              VerticalSpace(3),
              SizedBox(
                width: SizeConfig.screenWidth! * 0.85,
                child: CustomGenralButton(
                  text: 'Get Started',
                  onTap: () {
                    NavigationHelper.toLogin(context, replace: true);
                  },
                ),
              ),
              VerticalSpace(1),
              SizedBox(
                width: SizeConfig.screenWidth! * 0.85,
                child: CustomLoginWithButton(
                  isLoading: state is AuthLoading,
                  text: 'Continue with Google',
                  imagePath: 'assets/icons/google_icon.png',
                  onTap: () {
                    context.read<AuthBloc>().add(GoogleSignInRequested());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
