import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/charging_station_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

class ChargingStationMarker extends StatelessWidget {
  const ChargingStationMarker({super.key, required this.station});

  final ChargingStationModel station;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        showBottomSheet(
          context: context,
          builder: (context) {
            return ChargingStationBottomSheet(station: station);
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            constraints: const BoxConstraints(maxWidth: 140),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: colors.onSurface, fontSize: 12),
                ),
                Text(
                  '${station.distance!.toInt()}Km',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: colors.onSurface, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            FontAwesomeIcons.chargingStation,
            color: station.isActive ? colors.primary : colors.secondary,
            size: 28,
          ),
        ],
      ),
    );
  }
}
