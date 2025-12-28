import 'package:ev_app/features/battery_monitoring/presentation/manager/cubit/battery_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChargingButton extends StatefulWidget {
  const ChargingButton({super.key, required this.buildContext});
  final BuildContext buildContext;

  @override
  State<ChargingButton> createState() => _ChargingButtonState();
}

class _ChargingButtonState extends State<ChargingButton> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.buildContext.read<BatteryCubit>().isCharging;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      isSelected: isSelected,
      onPressed: () {
        setState(() {
          isSelected = !isSelected;
        });
        if (isSelected) {
          widget.buildContext.read<BatteryCubit>().startCharging();
        } else {
          widget.buildContext.read<BatteryCubit>().stopCharging();
        }
      },
      icon: Icon(Icons.power_off_outlined, color: colors.onSurface),
      selectedIcon: Icon(Icons.power_outlined, color: colors.primary),
    );
  }
}
