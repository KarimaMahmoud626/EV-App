import 'package:dartz/dartz.dart';
import 'package:ev_app/core/errors/exceptions.dart';
import 'package:ev_app/core/errors/failures.dart';
import 'package:ev_app/core/utils/app_logger.dart';
import 'package:ev_app/features/charging_stations/data/dataSources/charging_station_remote_ds.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:ev_app/features/charging_stations/data/repos/charging_station_repo.dart';
import 'package:latlong2/latlong.dart';

/// Implementation of [ChargingStationRepo] that fetches charging station data.
///
/// Converts data layer exceptions to domain layer failures.
class ChargingStationRepoImpl extends ChargingStationRepo {
  final ChargingStationRemoteDs remoteDs;

  ChargingStationRepoImpl({required this.remoteDs});

  @override
  Future<Either<Failure, List<ChargingStationModel>>>
  getChargingStationList() async {
    try {
      AppLogger.debug('Fetching charging stations from remote data source');
      final stations = await remoteDs.getChargingStationList();

      AppLogger.info(
        'Successfully fetched ${stations.length} charging stations',
      );
      return Right(stations);
    } on NetworkException catch (e, stackTrace) {
      AppLogger.error(
        'Network error while fetching charging stations',
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e, stackTrace) {
      AppLogger.error(
        'Server error while fetching charging stations',
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on ParsingException catch (e, stackTrace) {
      AppLogger.error(
        'Parsing error while processing charging stations',
        e,
        stackTrace,
      );
      return Left(ParsingFailure(e.message));
    } on LocationException catch (e, stackTrace) {
      AppLogger.error(
        'Location error while fetching charging stations',
        e,
        stackTrace,
      );
      return Left(LocationFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error while fetching charging stations',
        e,
        stackTrace,
      );
      return Left(
        ServerFailure('Failed to load charging stations: ${e.toString()}'),
      );
    }
  }

  @override
  Future<LatLng> getUserLatLng() async {
    try {
      final userLatLng = await remoteDs.getUserLatLng();
      AppLogger.debug('Retrieved user location: $userLatLng');
      return userLatLng;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get user location', e, stackTrace);
      rethrow;
    }
  }
}
