import 'package:ev_app/core/utils/size_config.dart';
import 'package:ev_app/core/widgets/battery_indicator_cell.dart';
import 'package:flutter/material.dart';

class BatteryIndicator extends StatelessWidget {
  const BatteryIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: SizeConfig.screenHeight! * 0.2,
          width: SizeConfig.screenWidth! * 0.8,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child:
                    index < 4
                        ? BatteryIndicatorCell(isFilled: true)
                        : BatteryIndicatorCell(),
              );
            },
          ),
        ),
        Positioned(
          top: SizeConfig.defaultSize! * 7,
          left: SizeConfig.defaultSize! * 13,
          child: Icon(Icons.electric_bolt, size: 50, color: Colors.amberAccent),
        ),
      ],
    );
  }
}
