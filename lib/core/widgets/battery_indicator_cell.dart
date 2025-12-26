import 'package:ev_app/core/utils/size_config.dart';
import 'package:flutter/material.dart';

class BatteryIndicatorCell extends StatelessWidget {
  const BatteryIndicatorCell({super.key, this.isFilled = false});
  final bool? isFilled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: Duration(),
      height: SizeConfig.screenHeight! * 0.15,
      width: SizeConfig.screenWidth! * 0.1,
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(12),
        color: colors.surface,
      ),
      foregroundDecoration: BoxDecoration(
        color: isFilled! ? colors.primary : colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outline),
      ),
    );
  }
}
