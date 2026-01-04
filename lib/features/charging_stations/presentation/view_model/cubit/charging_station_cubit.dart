import 'package:equatable/equatable.dart';
import 'package:ev_app/core/utils/distance_calculator.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:ev_app/features/charging_stations/data/repos/charging_station_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

part 'charging_station_state.dart';

class ChargingStationCubit extends Cubit<ChargingStationState> {
  final ChargingStationRepo repo;

  ChargingStationCubit(this.repo) : super(ChargingStationInitial());

  Future<void> getStations() async {
    print('enter stations cubit');
    try {
      emit(ChargingStationLoading());
      final result = await repo.getChargingStationList();
      result.fold((e) => emit(ChargingStationFailure(e.toString())), (
        stations,
      ) async {
        if (stations.isEmpty) {
          emit(ChargingStationEmpty());
        } else {
          final userLatLng = await repo.getUserLatLng();
          final stationsWithDistance =
              stations.map((station) {
                final distance = LatLngDistanceCalculator.calculateDistanceKm(
                  lat1: userLatLng.latitude,
                  lon1: userLatLng.longitude,
                  lat2: station.latitude,
                  lon2: station.longitude,
                );

                return station.copyWith(distance: distance);
              }).toList();
          print('cubit:lat lng $userLatLng');
          emit(ChargingStationLoaded(stationsWithDistance, userLatLng));
        }
      });
    } catch (e) {
      Exception(e);
    }
  }
}
