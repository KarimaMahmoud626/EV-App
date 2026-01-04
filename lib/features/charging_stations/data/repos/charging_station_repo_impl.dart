import 'package:dartz/dartz.dart';
import 'package:ev_app/features/charging_stations/data/dataSources/charging_station_remote_ds.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:ev_app/features/charging_stations/data/repos/charging_station_repo.dart';
import 'package:latlong2/latlong.dart';

class ChargingStationRepoImpl extends ChargingStationRepo {
  final ChargingStationRemoteDs remoteDs;

  ChargingStationRepoImpl({required this.remoteDs});

  @override
  Future<Either<Exception, List<ChargingStationModel>>>
  getChargingStationList() async {
    print('repo');
    try {
      final stations = await remoteDs.getChargingStationList();

      print('stations $stations');
      return Right(stations);
    } catch (e) {
      return Left(Exception(e));
    }
  }

  @override
  Future<LatLng> getUserLatLng() async {
    final userLatLng = await remoteDs.getUserLatLng();
    print('user lat lng $userLatLng');
    return await remoteDs.getUserLatLng();
  }
}
