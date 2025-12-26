import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/stats_custom_card.dart';
import 'package:flutter/material.dart';

class StatsList extends StatelessWidget {
  const StatsList({super.key});

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
                  statsValue: '3.5 kW',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatsCustomCard(
                  icon: Icons.thermostat,
                  cardTitle: 'Temp',
                  statsValue: '25°C',
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
                  statsValue: '380V',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatsCustomCard(
                  icon: Icons.refresh,
                  cardTitle: 'Cycles',
                  statsValue: '1,250',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
