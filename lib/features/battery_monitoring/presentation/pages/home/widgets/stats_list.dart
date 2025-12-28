import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/stats_custom_card.dart';
import 'package:flutter/material.dart';

class StatsList extends StatelessWidget {
  const StatsList({
    super.key,
    required this.batteryPower,
    required this.batteryTemp,
    required this.batteryVolt,
    required this.cycleCount,
  });

  final double batteryPower;
  final double batteryTemp;
  final double batteryVolt;
  final int cycleCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          VerticalSpace(1),
          Row(
            children: [
              Expanded(
                child: StatsCustomCard(
                  icon: Icons.bolt,
                  cardTitle: 'Power',
                  statsValue: '${batteryPower.toInt()}',
                  valueUnit: 'kw',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatsCustomCard(
                  icon: Icons.thermostat,
                  cardTitle: 'Temp',
                  statsValue: '${batteryTemp.toInt()}°',
                  valueUnit: 'C',
                ),
              ),
            ],
          ),
          VerticalSpace(1),
          Row(
            children: [
              Expanded(
                child: StatsCustomCard(
                  icon: Icons.electric_meter,
                  cardTitle: 'Voltage',
                  statsValue: '${batteryVolt.toInt()}',
                  valueUnit: 'V',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatsCustomCard(
                  icon: Icons.refresh,
                  cardTitle: 'Cycles',
                  statsValue: '$cycleCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
