import 'package:ev_app/core/widgets/user_profile.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(flex: 1, child: UserProfile(user: user)),
          Expanded(
            flex: 0,
            child: Card(
              elevation: 3,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications, color: colors.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
