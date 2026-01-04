import 'package:equatable/equatable.dart';
import 'package:ev_app/core/constants.dart';

class StationConnectionModel extends Equatable {
  final String typeName;
  final int level;
  final int numConnectors;

  const StationConnectionModel({
    required this.typeName,
    required this.level,
    required this.numConnectors,
  });

  factory StationConnectionModel.fromJson(Map<String, dynamic> data) {
    return StationConnectionModel(
      typeName: data[kStationConnectionType],
      level: data[kStationConnectionLevel],
      numConnectors: data[kStationNumOfConnectors],
    );
  }

  @override
  List<Object?> get props => [typeName, level, numConnectors];
}
