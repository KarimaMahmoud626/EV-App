import 'package:ev_app/core/widgets/user_profile.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/battery_monitoring/presentation/widgets/charging_button.dart';
import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({
    super.key,
    required this.user,
    required this.buildContext,
  });

  final UserModel user;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(flex: 1, child: UserProfile(user: user)),
          Expanded(flex: 0, child: ChargingButton(buildContext: buildContext)),
        ],
      ),
    );
  }
}
