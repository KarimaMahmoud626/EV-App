import 'package:equatable/equatable.dart';
import 'package:ev_app/core/constants.dart';

class BatteryDataModel extends Equatable {
  final double soc;
  final double soh;
  final double voltage;
  final double current;
  final double temperature;
  final double power;
  final double estimatedRange;
  final Duration? timeToFull;
  final int cycleCount;
  final List<double> cellVoltages;
  final DateTime timestamp;

  const BatteryDataModel({
    required this.soc,
    required this.soh,
    required this.voltage,
    required this.current,
    required this.temperature,
    required this.power,
    required this.estimatedRange,
    required this.timeToFull,
    required this.cycleCount,
    required this.cellVoltages,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      kSoc: soc,
      kSoh: soh,
      kVoltage: voltage,
      kCurrent: current,
      kTemperature: temperature,
      kPower: power,
      kEstimatedRange: estimatedRange,
      kTimeToFull: timeToFull,
      kCycleCount: cycleCount,
      kCellVoltages: cellVoltages,
      kTimestamp: timestamp,
    };
  }

  @override
  List<Object?> get props => [
    soc,
    soh,
    voltage,
    current,
    temperature,
    power,
    estimatedRange,
    timeToFull,
    cycleCount,
    cellVoltages,
    timestamp,
  ];
}
