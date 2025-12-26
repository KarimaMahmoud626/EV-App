import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/core/widgets/user_profile.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/charging_progress_bar.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/widgets/soh_card.dart';
import 'package:flutter/material.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(flex: 1, child: UserProfile(user: user)),
                  Expanded(
                    flex: 0,
                    child: Card(
                      elevation: 3,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            VerticalSpace(2),
            ChargingProgressBar(soc: 70),
            VerticalSpace(3),
            SohCard(sohValue: 0.4),
          ],
        ),
      ),
    );
  }
}
