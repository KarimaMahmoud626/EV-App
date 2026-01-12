import 'package:equatable/equatable.dart';
import 'package:ev_app/core/constants/constants.dart';
import 'package:ev_app/features/charging_stations/data/utils/estimated_power_calculator.dart';

class StationConnectionModel extends Equatable {
  final String rawTypeName;
  final String displayName;
  final String? standard;
  final int? level;
  final int numConnectors;
  final double? estimatedPower;

  const StationConnectionModel({
    required this.rawTypeName,
    required this.displayName,
    this.standard,
    required this.level,
    required this.numConnectors,
    this.estimatedPower,
  });

  factory StationConnectionModel.fromJson(Map<String, dynamic> data) {
    final raw = (data[kStationConnectionType] as String?) ?? 'Unknown';

    final parts = raw.split(' - ');
    return StationConnectionModel(
      rawTypeName: raw,
      displayName: parts.first,
      standard: parts.length > 1 ? parts.last : null,
      level: data[kStationConnectionLevel] as int?,
      numConnectors: (data[kStationNumOfConnectors] as int?) ?? 0,
      estimatedPower: EstimatedPowerCalculator.estimatePower(
        level: data[kStationConnectionLevel] as int?,
        typeName: raw,
      ),
    );
  }

  @override
  List<Object?> get props => [
    rawTypeName,
    level,
    numConnectors,
    estimatedPower,
    displayName,
    standard,
  ];
}
