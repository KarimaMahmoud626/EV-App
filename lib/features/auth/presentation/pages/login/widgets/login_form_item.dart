import 'package:ev_app/core/widgets/custom_text_field.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:flutter/material.dart';

class LoginFormItem extends StatelessWidget {
  const LoginFormItem({
    super.key,
    required this.text,
    this.keyboardType,
    this.maxLines,
    this.onChanged,
    this.onSaved,
    this.icon,
    this.validator,
    this.suffixIcon,
  });

  final String text;
  final TextInputType? keyboardType;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final IconData? icon;
  final IconData? suffixIcon;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.left,
        ),
        VerticalSpace(1.5),
        CustomTextField(
          keyboardType: keyboardType,
          maxLines: maxLines,
          onSaved: onSaved,
          onChanged: onChanged,
          icon: icon,
          suffixIcon: suffixIcon,
        ),
      ],
    );
  }
}
