import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:latlong2/latlong.dart';

abstract class ChargingStationRemoteDs {
  Future<List<ChargingStationModel>> getChargingStationList();
  Future<LatLng> getUserLatLng();
}
