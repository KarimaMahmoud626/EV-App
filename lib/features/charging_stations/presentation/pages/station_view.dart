import 'package:ev_app/features/charging_stations/presentation/widgets/station_view_body.dart';
import 'package:flutter/material.dart';

class StationView extends StatelessWidget {
  const StationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StationViewBody());
  }
}
