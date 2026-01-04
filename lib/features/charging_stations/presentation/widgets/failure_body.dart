import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/charging_stations/presentation/view_model/cubit/charging_station_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FailureBody extends StatelessWidget {
  const FailureBody({
    super.key,
    required this.state,
    required this.buildContext,
  });

  final ChargingStationFailure state;
  final BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colors.error),
            VerticalSpace(2),
            Text(
              'Failed to Load Stations',
              style: TextStyle(
                color: colors.onBackground,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            VerticalSpace(1),
            Text(
              state.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
            VerticalSpace(3),
            ElevatedButton.icon(
              onPressed: () {
                buildContext.read<ChargingStationCubit>().getStations();
              },
              icon: Icon(Icons.refresh, color: colors.onPrimary, size: 24),
              label: Text(
                'Retry',
                style: TextStyle(color: colors.onPrimary, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
