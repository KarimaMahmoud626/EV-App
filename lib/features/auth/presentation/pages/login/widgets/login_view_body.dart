import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/custom_buttons.dart';
import 'package:ev_app/core/widgets/custom_line.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/auth/presentation/pages/login/widgets/login_form_item.dart';
import 'package:flutter/material.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final colors = Theme.of(context).colorScheme;
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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoginFormItem(text: 'Full Name', icon: Icons.person),
                  VerticalSpace(2.5),
                  LoginFormItem(
                    text: 'Email Address',
                    icon: Icons.email_rounded,
                  ),
                  VerticalSpace(2.5),
                  LoginFormItem(
                    text: 'Password',
                    icon: Icons.lock_rounded,
                    suffixIcon: Icons.visibility_outlined,
                  ),
                ],
              ),
            ),
            VerticalSpace(4),
            CustomLoginButton(),
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
              text: 'Google',
              imagePath: 'assets/icons/google_icon.png',
            ),
          ],
        ),
      ),
    );
  }
}
