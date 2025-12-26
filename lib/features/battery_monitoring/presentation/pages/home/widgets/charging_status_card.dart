import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/charging_status_item.dart';
import 'package:flutter/material.dart';

class ChargingStatusCard extends StatelessWidget {
  const ChargingStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Charging Status',
          style: TextStyle(
            color: colors.onBackground,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        VerticalSpace(1),
        Container(
          width: SizeConfig.screenWidth! * 0.9,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            elevation: 3,
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ChargingStatusItem(
                    icon: Icons.electric_bolt,
                    statusItem: 'Fast Charging',
                  ),
                  ChargingStatusItem(
                    icon: Icons.timer,
                    statusItem: 'Time to Full',
                    statusItemValue: '1h 30m',
                  ),
                  VerticalSpace(0.5),
                  ChargingStatusItem(
                    icon: Icons.bar_chart_rounded,
                    statusItem: 'Charge Rate',
                    statusItemValue: '50Kw',
                  ),
                  VerticalSpace(0.5),
                  ChargingStatusItem(
                    icon: Icons.battery_charging_full_rounded,
                    statusItem: 'Target',
                    statusItemValue: '80%',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
