import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/services/color_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

class SohCard extends StatelessWidget {
  const SohCard({super.key, required this.sohValue});

  final double sohValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final indicatorColor = ColorServices().sohGradient(colors, sohValue);
    return Container(
      width: SizeConfig.screenWidth! * 0.9,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Card(
            elevation: 3,
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(FontAwesomeIcons.heartPulse, color: colors.secondary),
                  VerticalSpace(2),
                  Text(
                    'Battery SoH',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  VerticalSpace(0.5),
                  SizedBox(
                    height: 8,
                    child: ShaderMask(
                      shaderCallback: (bonus) {
                        return indicatorColor.createShader(bonus);
                      },
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(12),
                        value: sohValue,
                        backgroundColor: colors.onSurfaceVariant.withOpacity(
                          0.5,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  VerticalSpace(0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0%',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '100%',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: SizeConfig.defaultSize! * 4,
            right: SizeConfig.defaultSize! * 2,
            child: Row(
              children: [
                Text(
                  '${(sohValue * 100).toInt()}',
                  style: TextStyle(fontSize: 48),
                ),
                Text('%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
