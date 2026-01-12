import 'package:equatable/equatable.dart';
import 'package:ev_app/core/constants/constants.dart';
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
    final stationConnections =
        (jsonData[kStationConnections] as List)
            .map(
              (connection) => StationConnectionModel.fromJson(
                connection as Map<String, dynamic>,
              ),
            )
            .toList();
    return ChargingStationModel(
      isActive: jsonData[kStationIsActive] as bool,
      address: jsonData[kStationAddress] as String,
      name: jsonData[kStationName] as String,
      latitude: jsonData[kStationLatitude] as double,
      longitude: jsonData[kStationLongitude] as double,
      connections: stationConnections,
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
