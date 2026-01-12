import 'package:equatable/equatable.dart';
import 'package:ev_app/core/errors/failures.dart';
import 'package:ev_app/core/utils/app_logger.dart';
import 'package:ev_app/core/utils/distance_calculator.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:ev_app/features/charging_stations/data/repos/charging_station_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

part 'charging_station_state.dart';

/// Manages charging station state and handles fetching station data.
///
/// This Cubit fetches nearby charging stations, calculates distances,
/// and emits appropriate states during the loading process.
class ChargingStationCubit extends Cubit<ChargingStationState> {
  final ChargingStationRepo repo;

  ChargingStationCubit(this.repo) : super(ChargingStationInitial());

  /// Fetches charging stations near the user's current location.
  ///
  /// Emits states in the following order:
  /// 1. [ChargingStationLoading] - While fetching data
  /// 2. [ChargingStationEmpty] - If no stations found
  /// 3. [ChargingStationLoaded] - If stations found (with distances calculated)
  /// 4. [ChargingStationFailure] - If an error occurs
  Future<void> getStations() async {
    try {
      AppLogger.info('Fetching charging stations');
      emit(ChargingStationLoading());

      final result = await repo.getChargingStationList();

      result.fold(
        (failure) {
          AppLogger.error(
            'Failed to fetch charging stations: ${failure.message}',
          );
          emit(ChargingStationFailure(_getErrorMessage(failure)));
        },
        (stations) async {
          if (stations.isEmpty) {
            AppLogger.info('No charging stations found in the area');
            emit(ChargingStationEmpty());
          } else {
            AppLogger.info('Found ${stations.length} charging stations');

            // Get user location and calculate distances
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

            AppLogger.debug('User location: $userLatLng');
            emit(ChargingStationLoaded(stationsWithDistance, userLatLng));
          }
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error while fetching charging stations',
        e,
        stackTrace,
      );
      emit(
        ChargingStationFailure(
          'Failed to load charging stations. Please try again.',
        ),
      );
    }
  }

  /// Converts a [Failure] to a user-friendly error message.
  ///
  /// Provides specific messages for different failure types.
  String _getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    } else if (failure is LocationFailure) {
      return 'Unable to access your location. Please enable location services.';
    } else if (failure is ServerFailure) {
      return 'Server error. Please try again later.';
    } else {
      return 'Failed to load charging stations. Please try again.';
    }
  }
}
