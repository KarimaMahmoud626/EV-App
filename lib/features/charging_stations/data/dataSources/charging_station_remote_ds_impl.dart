import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ev_app/core/config/env_config.dart';
import 'package:ev_app/core/errors/exceptions.dart';
import 'package:ev_app/core/services/location_services.dart';
import 'package:ev_app/core/utils/app_logger.dart';
import 'package:ev_app/features/charging_stations/data/dataSources/charging_station_remote_ds.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Implementation of [ChargingStationRemoteDs] that fetches data from API Ninjas EV Charger API.
///
/// Handles network requests, error handling, and data parsing for charging station information.
class ChargingStationRemoteDsImpl extends ChargingStationRemoteDs {
  final LocationService locationService;
  final http.Client client;

  ChargingStationRemoteDsImpl({
    required this.locationService,
    required this.client,
  });

  @override
  Future<List<ChargingStationModel>> getChargingStationList() async {
    try {
      // Get user's current location
      final position = await locationService.getCurrentLocation();
      AppLogger.debug(
        'User position: lat=${position.latitude}, lon=${position.longitude}',
      );

      // Build API URL
      final url = Uri.parse(
        'https://api.api-ninjas.com/v1/evcharger?lat=${position.latitude}&lon=${position.longitude}&distance=50',
      );

      // Make HTTP request with timeout
      final response = await client
          .get(url, headers: {'X-Api-Key': EnvConfig.evChargerApiKey})
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw NetworkException('Connection timeout'),
          );

      AppLogger.debug('API response status: ${response.statusCode}');

      // Handle different HTTP status codes
      if (response.statusCode == 200) {
        return _parseStationsFromResponse(response.body);
      } else if (response.statusCode >= 500) {
        throw ServerException(
          'Server error occurred',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401) {
        throw ServerException('Invalid API key', statusCode: 401);
      } else if (response.statusCode == 404) {
        throw ServerException('API endpoint not found', statusCode: 404);
      } else {
        throw ServerException(
          'Failed to load charging stations',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e, stackTrace) {
      AppLogger.error(
        'Network error while fetching charging stations',
        e,
        stackTrace,
      );
      throw NetworkException('No internet connection');
    } on TimeoutException catch (e, stackTrace) {
      AppLogger.error(
        'Timeout while fetching charging stations',
        e,
        stackTrace,
      );
      throw NetworkException('Connection timeout');
    } on FormatException catch (e, stackTrace) {
      AppLogger.error(
        'Invalid response format from charging stations API',
        e,
        stackTrace,
      );
      throw ParsingException('Invalid response format');
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on LocationException {
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error while fetching charging stations',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to load charging stations: ${e.toString()}',
      );
    }
  }

  /// Parses the JSON response body into a list of charging station models.
  ///
  /// Handles invalid station data gracefully by skipping problematic entries
  /// and logging warnings.
  List<ChargingStationModel> _parseStationsFromResponse(String responseBody) {
    final stations = <ChargingStationModel>[];

    try {
      final jsonData = jsonDecode(responseBody);

      if (jsonData is! List) {
        throw ParsingException(
          'Expected a list of stations but got ${jsonData.runtimeType}',
        );
      }

      if (jsonData.isEmpty) {
        AppLogger.info('No charging stations found in the area');
        return stations;
      }

      AppLogger.info('Found ${jsonData.length} charging stations');

      for (var stationJson in jsonData) {
        try {
          stations.add(
            ChargingStationModel.fromJson(stationJson as Map<String, dynamic>),
          );
        } catch (e) {
          AppLogger.warning('Failed to parse charging station', e);
          // Continue with other stations instead of failing completely
        }
      }

      AppLogger.debug(
        'Successfully parsed ${stations.length} out of ${jsonData.length} stations',
      );
      return stations;
    } catch (e) {
      if (e is ParsingException) rethrow;
      throw ParsingException(
        'Failed to parse charging stations response: ${e.toString()}',
      );
    }
  }

  @override
  Future<LatLng> getUserLatLng() async {
    try {
      final position = await locationService.getCurrentLocation();
      AppLogger.debug(
        'User location: lat=${position.latitude}, lon=${position.longitude}',
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get user location', e, stackTrace);
      rethrow;
    }
  }
}
