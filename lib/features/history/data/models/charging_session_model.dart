import 'package:equatable/equatable.dart';

/// Represents a single charging session.
///
/// Contains information about when the charging started, ended,
/// energy consumed, cost, and location.
class ChargingSessionModel extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final double energyAdded; // in kWh
  final double startSoc; // State of Charge at start (0-100)
  final double endSoc; // State of Charge at end (0-100)
  final double cost; // in currency units
  final String location;
  final ChargingType chargingType;
  final double peakPower; // Maximum power during session in kW

  const ChargingSessionModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.energyAdded,
    required this.startSoc,
    required this.endSoc,
    required this.cost,
    required this.location,
    required this.chargingType,
    required this.peakPower,
  });

  /// Duration of the charging session
  Duration get duration => endTime.difference(startTime);

  /// Average power during the session in kW
  double get averagePower {
    final hours = duration.inMinutes / 60.0;
    return hours > 0 ? energyAdded / hours : 0;
  }

  /// SOC gained during session
  double get socGained => endSoc - startSoc;

  @override
  List<Object?> get props => [
    id,
    startTime,
    endTime,
    energyAdded,
    startSoc,
    endSoc,
    cost,
    location,
    chargingType,
    peakPower,
  ];
}

/// Types of charging sessions
enum ChargingType {
  home,
  public,
  fast,
  supercharger;

  String get displayName {
    switch (this) {
      case ChargingType.home:
        return 'Home';
      case ChargingType.public:
        return 'Public';
      case ChargingType.fast:
        return 'Fast Charge';
      case ChargingType.supercharger:
        return 'Supercharger';
    }
  }
}
