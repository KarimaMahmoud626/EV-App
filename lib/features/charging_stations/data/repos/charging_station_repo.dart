import 'package:dartz/dartz.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:latlong2/latlong.dart';

abstract class ChargingStationRepo {
  Future<Either<Exception, List<ChargingStationModel>>>
  getChargingStationList();

  Future<LatLng> getUserLatLng();
}
