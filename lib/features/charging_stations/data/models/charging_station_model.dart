import 'package:equatable/equatable.dart';
import 'package:ev_app/core/constants.dart';
import 'package:ev_app/features/charging_stations/data/models/station_connection_model.dart';

class ChargingStationModel extends Equatable {
  final bool isActive;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<StationConnectionModel> connections;
  final double? distance;

  const ChargingStationModel({
    required this.isActive,
    required this.address,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.connections,
    this.distance,
  });

  factory ChargingStationModel.fromJson(Map<String, dynamic> jsonData) {
    final stationConnections = jsonData[kStationConnections] as List;
    return ChargingStationModel(
      isActive: jsonData[kStationIsActive],
      address: jsonData[kStationAddress],
      name: jsonData[kStationName],
      latitude: jsonData[kStationLatitude],
      longitude: jsonData[kStationLongitude],
      connections:
          stationConnections
              .map((connection) => StationConnectionModel.fromJson(connection))
              .toList(),
    );
  }

  ChargingStationModel copyWith({double? distance}) {
    return ChargingStationModel(
      isActive: isActive,
      address: address,
      name: name,
      latitude: latitude,
      longitude: longitude,
      connections: connections,
      distance: distance ?? this.distance,
    );
  }

  @override
  List<Object?> get props => [
    isActive,
    name,
    address,
    latitude,
    longitude,
    connections,
    distance,
  ];
}
