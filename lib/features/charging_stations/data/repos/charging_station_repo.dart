import 'package:dartz/dartz.dart';
import 'package:ev_app/core/errors/failures.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:latlong2/latlong.dart';

/// Abstract repository for charging station operations.
///
/// Defines the contract for charging station-related operations.
/// Returns Either<Failure, T> for functional error handling.
abstract class ChargingStationRepo {
  /// Fetches a list of charging stations near the user's current location.
  ///
  /// Returns a list of [ChargingStationModel] on success or [Failure] on error.
  Future<Either<Failure, List<ChargingStationModel>>> getChargingStationList();

  /// Gets the user's current location as latitude/longitude.
  ///
  /// Returns [LatLng] on success or throws [LocationException] on error.
  Future<LatLng> getUserLatLng();
}
