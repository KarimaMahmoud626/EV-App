import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:flutter/material.dart';

class CustomLoginButton extends StatelessWidget {
  const CustomLoginButton({super.key, this.onTap, this.isLoading = false});

  final void Function()? onTap;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: colors.onPrimary),
                  )
                  : Text(
                    'Login',
                    style: TextStyle(
                      color: colors.onPrimaryFixedVariant,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }
}

class CustomLoginWithButton extends StatelessWidget {
  const CustomLoginWithButton({
    super.key,
    this.imagePath,
    required this.text,
    this.onTap,
    this.isLoading,
  });

  final String? imagePath;
  final String text;
  final void Function()? onTap;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: colors.secondary,
          border: Border.all(color: colors.onSecondaryContainer),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30, width: 30, child: Image.asset(imagePath!)),
            HorizontalSpace(2),
            isLoading!
                ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: colors.onPrimary),
                )
                : Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: colors.onSecondary,
                  ),
                  textAlign: TextAlign.left,
                ),
          ],
        ),
      ),
    );
  }
}
