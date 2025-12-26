import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/core/widgets/user_profile_header.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/charging_progress_bar.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/charging_status_card.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/soh_card.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/stats_list.dart';
import 'package:flutter/material.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            UserProfileHeader(user: user),
            VerticalSpace(2),
            ChargingProgressBar(soc: 70),
            VerticalSpace(2),
            StatsList(),
            VerticalSpace(1.5),
            ChargingStatusCard(),
            VerticalSpace(1),
            SohCard(sohValue: 0.4),
          ],
        ),
      ),
    );
  }
}
