import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/battery_monitoring/presentation/view_model/cubit/battery_cubit.dart';
import 'package:ev_app/features/battery_monitoring/presentation/widgets/charging_button.dart';
import 'package:ev_app/features/battery_monitoring/presentation/widgets/charging_progress_bar.dart';
import 'package:ev_app/features/battery_monitoring/presentation/widgets/charging_status_card.dart';
import 'package:ev_app/features/battery_monitoring/presentation/widgets/error_view.dart';
import 'package:ev_app/features/battery_monitoring/presentation/widgets/settings_button.dart';
import 'package:ev_app/features/battery_monitoring/presentation/widgets/soh_card.dart';
import 'package:ev_app/features/battery_monitoring/presentation/widgets/stats_list.dart';
import 'package:ev_app/features/battery_monitoring/presentation/widgets/theme_toggle_button.dart';
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const Text(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SettingsButton(user: user),
                        Spacer(),
                        ChargingButton(buildContext: context),
                      ],
                    ),
                  ),
                  const VerticalSpace(2),
                  ChargingProgressBar(
                    soc: state.data.soc,
                    estimatedRange: state.data.estimatedRange,
                  ),
                  const VerticalSpace(2),
                  StatsList(
                    batteryPower: state.data.power,
                    cycleCount: state.data.cycleCount,
                    batteryVolt: state.data.voltage,
                    batteryTemp: state.data.temperature,
                  ),
                  const VerticalSpace(1.5),
                  ChargingStatusCard(
                    targetCharge: state.data.targetSoc,
                    timeToFull: state.data.timeToFull,
                  ),
                  const VerticalSpace(1),
                  SohCard(sohValue: state.data.soh / 100),
                ],
              ),
            ),
          );
        } else if (state is BatteryError) {
          return ErrorView(context: context, message: state.message);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
