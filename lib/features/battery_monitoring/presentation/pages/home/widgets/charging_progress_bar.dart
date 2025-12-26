import 'package:dashed_progress_bar/dashed_progress_bar.dart';
import 'package:ev_app/core/widgets/space.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/services/color_services.dart';
import 'package:flutter/material.dart';

class ChargingProgressBar extends StatelessWidget {
  const ChargingProgressBar({super.key, required this.soc});

  final double soc;

  @override
  Widget build(BuildContext context) {
    final _valueNotifier = ValueNotifier<double>(0);
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: ColorServices().circularShadow(colors),
      ),
      child: CircleAvatar(
        radius: 120,
        backgroundColor: colors.surface,
        child: DashedCircularProgressBar.aspectRatio(
          aspectRatio: 1,
          valueNotifier: _valueNotifier,
          progress: soc,
          startAngle: 225,
          sweepAngle: 270,
          foregroundColor: ColorServices().getSOCColor(colors, soc),
          backgroundColor: colors.onSurfaceVariant.withOpacity(0.5),
          foregroundStrokeWidth: 15,
          backgroundStrokeWidth: 15,
          animation: true,
          seekSize: 6,
          seekColor: colors.onSurfaceVariant,
          child: Center(
            child: ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder:
                  (_, double value, __) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.electric_bolt,
                        size: 48,
                        color: colors.secondary,
                      ),
                      VerticalSpace(.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              fontSize: 42,
                              color: colors.onSurface,
                            ),
                          ),
                          Text('%', style: TextStyle(color: colors.onSurface)),
                        ],
                      ),
                      VerticalSpace(1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.speed, size: 32, color: colors.secondary),
                          HorizontalSpace(.5),
                          Text(
                            '300',
                            style: TextStyle(
                              fontSize: 42,
                              color: colors.onSurface,
                            ),
                          ),
                          Text('Km', style: TextStyle(color: colors.onSurface)),
                        ],
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
