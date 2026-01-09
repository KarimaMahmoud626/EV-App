import 'package:ev_app/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final themeMode = context.watch<ThemeCubit>().state;

    final isDark = themeMode == ThemeMode.dark;
    final controller = ValueNotifier<bool>(isDark);

    return AdvancedSwitch(
      controller: controller,
      width: 60,
      borderRadius: BorderRadius.circular(16),

      activeChild: Icon(Icons.dark_mode, color: colors.primary),
      inactiveChild: Icon(Icons.light_mode, color: colors.primary),

      activeColor: colors.surface,
      inactiveColor: colors.surface,

      onChanged: (value) {
        if (value) {
          context.read<ThemeCubit>().setDark();
        } else {
          context.read<ThemeCubit>().setLight();
        }
      },
    );
  }
}
