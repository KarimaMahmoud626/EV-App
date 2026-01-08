import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/charging_stations/data/models/station_connection_model.dart';
import 'package:flutter/material.dart';

class ConnectorsPowerInfo extends StatelessWidget {
  const ConnectorsPowerInfo({super.key, required this.connections});

  final List<StationConnectionModel> connections;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            connections.map((connector) {
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: colors.secondary),
                        HorizontalSpace(0.5),
                        Text(
                          connector.displayName,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  HorizontalSpace(5),
                  Expanded(
                    flex: 0,
                    child: Text(
                      '~${connector.estimatedPower}Kw',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
