import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/custom_buttons.dart';
import 'package:ev_app/core/widgets/rounded_rectangle_image_container.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/charging_station_info_item.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/connectors_power_info.dart';
import 'package:flutter/material.dart';

class ChargingStationBottomSheet extends StatelessWidget {
  const ChargingStationBottomSheet({super.key, required this.station});

  final ChargingStationModel station;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: SizeConfig.screenWidth! * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                station.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                station.address,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.left,
              ),
              VerticalSpace(3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChargingStationInfoItem(
                    icon: Icons.power,
                    data: '${station.connections.length} available connectors',
                  ),
                  VerticalSpace(1),
                  ChargingStationInfoItem(
                    icon: Icons.electric_bolt_sharp,
                    data: 'Connection Estimated Power',
                  ),
                  VerticalSpace(0.5),
                  ConnectorsPowerInfo(connections: station.connections),
                ],
              ),
              VerticalSpace(2),
              SizedBox(
                height: 50,
                child: CustomGenralButton(text: 'Directions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
