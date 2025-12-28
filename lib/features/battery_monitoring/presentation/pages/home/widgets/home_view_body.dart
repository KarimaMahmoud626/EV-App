import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/core/widgets/user_profile_header.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/battery_monitoring/presentation/manager/cubit/battery_cubit.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/charging_progress_bar.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/charging_status_card.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/error_view.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/soh_card.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/stats_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<BatteryCubit, BatteryState>(
      builder: (context, state) {
        if (state is BatteryLoading) {
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text(
                  'Connecting to battery...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        } else if (state is BatteryMonitoring) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  UserProfileHeader(user: user, buildContext: context),
                  VerticalSpace(2),
                  ChargingProgressBar(
                    soc: state.data.soc,
                    estimatedRange: state.data.estimatedRange,
                  ),
                  VerticalSpace(2),
                  StatsList(
                    batteryPower: state.data.power,
                    cycleCount: state.data.cycleCount,
                    batteryVolt: state.data.voltage,
                    batteryTemp: state.data.temperature,
                  ),
                  VerticalSpace(1.5),
                  ChargingStatusCard(
                    targetCharge: state.data.targetSoc,
                    timeToFull: state.data.timeToFull,
                  ),
                  VerticalSpace(1),
                  SohCard(sohValue: state.data.soh / 100),
                ],
              ),
            ),
          );
        } else if (state is BatteryError) {
          return ErrorView(context: context, message: state.message);
        } else {
          return Text('data');
        }
      },
    );
  }
}
