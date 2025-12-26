import 'package:ev_app/core/widgets/custom_title_subtiltle.dart';
import 'package:ev_app/core/widgets/user_avatar.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        UserAvatar(),
        CustomTitleSubtitle(
          title: user.name,
          subTitle: '',
          titleColor: colors.onSurface,
          subTitleColor: colors.onSurface,
        ),
      ],
    );
  }
}
