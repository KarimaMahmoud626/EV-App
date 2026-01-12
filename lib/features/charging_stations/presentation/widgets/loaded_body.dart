import 'package:ev_app/features/charging_stations/presentation/view_model/cubit/charging_station_cubit.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/charging_station_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LoadedBody extends StatelessWidget {
  const LoadedBody({super.key, required this.state});
  final ChargingStationLoaded state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FlutterMap(
      options: MapOptions(
        initialCenter: state.userLatLng,
        initialZoom: 13,
        backgroundColor: colors.background,
      ),
      children: [
        TileLayer(
          urlTemplate:
              isDark
                  ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                  : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c', 'd'],
        ),
        MarkerLayer(
          markers:
              state.stations.map((station) {
                return Marker(
                  width: 160,
                  height: 100,
                  point: LatLng(station.latitude, station.longitude),
                  child: ChargingStationMarker(station: station),
                );
              }).toList(),
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: state.userLatLng,
              child: Icon(Icons.electric_car, color: colors.primary, size: 32),
            ),
          ],
        ),
      ],
    );
  }
}
