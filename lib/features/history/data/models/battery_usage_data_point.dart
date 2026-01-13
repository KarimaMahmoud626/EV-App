import 'package:equatable/equatable.dart';

/// Represents a single data point for battery usage over time.
///
/// Used for visualizing battery usage trends in graphs.
class BatteryUsageDataPoint extends Equatable {
  final DateTime timestamp;
  final double batteryLevel; // State of Charge (0-100)
  final double energyConsumed; // kWh consumed since last data point
  final double? temperature; // Optional battery temperature in Celsius

  const BatteryUsageDataPoint({
    required this.timestamp,
    required this.batteryLevel,
    required this.energyConsumed,
    this.temperature,
  });

  @override
  List<Object?> get props => [
    timestamp,
    batteryLevel,
    energyConsumed,
    temperature,
  ];
}

/// Aggregated battery usage statistics for a time period
class BatteryUsageStats extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final double totalEnergyConsumed; // Total kWh consumed
  final double averageEfficiency; // km per kWh
  final int numberOfCharges;
  final List<BatteryUsageDataPoint> dataPoints;

  const BatteryUsageStats({
    required this.startDate,
    required this.endDate,
    required this.totalEnergyConsumed,
    required this.averageEfficiency,
    required this.numberOfCharges,
    required this.dataPoints,
  });

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    totalEnergyConsumed,
    averageEfficiency,
    numberOfCharges,
    dataPoints,
  ];
}
