import 'package:ev_app/core/widgets/space.dart';
import 'package:flutter/material.dart';

class ChargingStatusItem extends StatelessWidget {
  const ChargingStatusItem({
    super.key,
    required this.icon,
    required this.statusItem,
    this.statusItemValue,
  });
  final IconData icon;
  final String statusItem;
  final String? statusItemValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: colors.secondary, size: 16),
        HorizontalSpace(1),
        Expanded(
          flex: 1,
          child: Text(
            statusItem,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 0,
          child: Text(
            statusItemValue ?? '',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
