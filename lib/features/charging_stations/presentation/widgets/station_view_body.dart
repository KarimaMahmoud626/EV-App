import 'package:ev_app/features/charging_stations/presentation/view_model/cubit/charging_station_cubit.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/empty_body.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/failure_body.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/loaded_body.dart';
import 'package:ev_app/features/charging_stations/presentation/widgets/loading_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StationViewBody extends StatelessWidget {
  const StationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationCubit, ChargingStationState>(
      builder: (context, state) {
        if (state is ChargingStationLoading) {
          return LoadingBody();
        }

        if (state is ChargingStationFailure) {
          return FailureBody(state: state, buildContext: context);
        }

        if (state is ChargingStationEmpty) {
          return EmptyBody(buildContext: context);
        }

        if (state is ChargingStationLoaded) {
          return LoadedBody(state: state);
        }

        return const SizedBox();
      },
    );
  }
}
