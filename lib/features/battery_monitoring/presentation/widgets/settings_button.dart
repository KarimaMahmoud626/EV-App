import 'package:flutter/material.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: IconButton(
        icon: Icon(Icons.settings_outlined),
        onPressed: () {
          Navigator.pushNamed(context, '/settings', arguments: user);
        },
        tooltip: 'Settings',
      ),
    );
  }
}
