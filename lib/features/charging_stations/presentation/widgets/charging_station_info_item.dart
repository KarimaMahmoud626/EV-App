import 'package:ev_app/core/widgets/space.dart';
import 'package:flutter/material.dart';

class ChargingStationInfoItem extends StatelessWidget {
  const ChargingStationInfoItem({
    super.key,
    required this.icon,
    required this.data,
  });
  final IconData icon;
  final String data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 22),
        HorizontalSpace(0.5),
        Text(
          data,
          style: TextStyle(
            fontSize: 20,
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
