import 'dart:convert';

import 'package:ev_app/core/services/location_services.dart';
import 'package:ev_app/features/charging_stations/data/dataSources/charging_station_remote_ds.dart';
import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class ChargingStationRemoteDsImpl extends ChargingStationRemoteDs {
  final LocationService locationService;

  ChargingStationRemoteDsImpl({required this.locationService});

  @override
  Future<List<ChargingStationModel>> getChargingStationList() async {
    final List<ChargingStationModel> stations = [];
    try {
      final position = await locationService.getCurrentLocation();
      print('user position $position');
      final url = Uri.parse(
        'https://api.api-ninjas.com/v1/evcharger?lat=${position.latitude}&lon=${position.longitude}&distance=50',
      );
      http.Response response = await http
          .get(
            url,
            headers: {'X-Api-Key': '9aFlhzHXHgpIr8/beuR9mQ==sKyso8HeEmZV0SEy'},
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );
      print('📥 Response status: ${response.statusCode}');
      print('📄 Response body preview: ${response.body.substring(0, 200)}...');
      if (response.statusCode != 200) {
        throw (Exception('HTTP error ${response.statusCode}'));
      }
      final jsonData = jsonDecode(response.body);

      if (jsonData is List && jsonData.isNotEmpty) {
        print('✅ Found ${jsonData.length} stations');
        for (var station in jsonData) {
          try {
            stations.add(ChargingStationModel.fromJson(station));
          } catch (e) {
            print('⚠️ Error parsing station: $e');
            // Skip invalid stations
          }
        }
      } else {
        print('⚠️ No stations found in response');
      }
      return stations;
    } catch (e) {
      throw (Exception(e));
    }
  }

  @override
  Future<LatLng> getUserLatLng() async {
    final position = await locationService.getCurrentLocation();
    print('user position:$position');
    return LatLng(position.latitude, position.longitude);
  }
}
