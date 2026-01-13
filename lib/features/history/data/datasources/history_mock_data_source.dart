import 'dart:math';
import 'package:ev_app/features/history/data/models/battery_usage_data_point.dart';
import 'package:ev_app/features/history/data/models/charging_session_model.dart';

/// Mock data source for charging history and battery usage data.
///
/// Generates realistic mock data for development and testing purposes.
class HistoryMockDataSource {
  final Random _random = Random();

  /// Generates mock charging sessions for the past 30 days
  List<ChargingSessionModel> generateChargingSessions() {
    final sessions = <ChargingSessionModel>[];
    final now = DateTime.now();

    // Generate 15-20 charging sessions over the past 30 days
    final sessionCount = 15 + _random.nextInt(6);

    for (int i = 0; i < sessionCount; i++) {
      final daysAgo = _random.nextInt(30);
      final startTime = now.subtract(
        Duration(
          days: daysAgo,
          hours: _random.nextInt(24),
          minutes: _random.nextInt(60),
        ),
      );

      // Charging duration: 20 minutes to 4 hours
      final durationMinutes = 20 + _random.nextInt(220);
      final endTime = startTime.add(Duration(minutes: durationMinutes));

      final chargingType =
          ChargingType.values[_random.nextInt(ChargingType.values.length)];
      final startSoc = 15.0 + _random.nextDouble() * 40; // 15-55%
      final socGained = 30.0 + _random.nextDouble() * 50; // 30-80%
      final double endSoc = (startSoc + socGained).clamp(0, 100);

      // Energy added based on SOC gained (assuming ~75 kWh battery)
      final energyAdded = (socGained / 100) * 75;

      // Peak power based on charging type
      final peakPower = _getPeakPowerForType(chargingType);

      // Cost calculation (varies by charging type)
      final costPerKwh = _getCostPerKwhForType(chargingType);
      final cost = energyAdded * costPerKwh;

      sessions.add(
        ChargingSessionModel(
          id: 'session_$i',
          startTime: startTime,
          endTime: endTime,
          energyAdded: energyAdded,
          startSoc: startSoc,
          endSoc: endSoc,
          cost: cost,
          location: _getLocationForType(chargingType),
          chargingType: chargingType,
          peakPower: peakPower,
        ),
      );
    }

    // Sort by start time (most recent first)
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions;
  }

  /// Generates battery usage data points for visualization
  List<BatteryUsageDataPoint> generateBatteryUsageData({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final dataPoints = <BatteryUsageDataPoint>[];
    final daysDifference = endDate.difference(startDate).inDays;

    // Generate data points (one per day for daily view, one per hour for weekly view)
    final pointCount =
        daysDifference <= 7 ? daysDifference * 24 : daysDifference;
    final interval =
        daysDifference <= 7
            ? const Duration(hours: 1)
            : const Duration(days: 1);

    var currentTime = startDate;
    var currentBatteryLevel =
        85.0 + _random.nextDouble() * 10; // Start at 85-95%

    for (int i = 0; i < pointCount; i++) {
      // Simulate battery drain and charging
      final isCharging = _random.nextDouble() < 0.15; // 15% chance of charging

      if (isCharging) {
        // Charging: increase battery level
        final chargeAmount = 20 + _random.nextDouble() * 40;
        currentBatteryLevel = (currentBatteryLevel + chargeAmount).clamp(
          0,
          100,
        );
      } else {
        // Discharging: decrease battery level
        final drainAmount = _random.nextDouble() * 5;
        currentBatteryLevel = (currentBatteryLevel - drainAmount).clamp(
          10,
          100,
        );
      }

      // Energy consumed (negative when charging)
      final energyConsumed =
          isCharging ? -(_random.nextDouble() * 10) : _random.nextDouble() * 3;

      // Battery temperature
      final temperature = 20 + _random.nextDouble() * 15; // 20-35°C

      dataPoints.add(
        BatteryUsageDataPoint(
          timestamp: currentTime,
          batteryLevel: currentBatteryLevel,
          energyConsumed: energyConsumed,
          temperature: temperature,
        ),
      );

      currentTime = currentTime.add(interval);
    }

    return dataPoints;
  }

  /// Generates battery usage statistics for a period
  BatteryUsageStats generateBatteryUsageStats({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final dataPoints = generateBatteryUsageData(
      startDate: startDate,
      endDate: endDate,
    );

    final totalEnergyConsumed = dataPoints
        .where((point) => point.energyConsumed > 0)
        .fold(0.0, (sum, point) => sum + point.energyConsumed);

    // Mock efficiency: 4-6 km per kWh
    final averageEfficiency = 4.0 + _random.nextDouble() * 2;

    // Count charging events (when battery level increases significantly)
    int numberOfCharges = 0;
    for (int i = 1; i < dataPoints.length; i++) {
      if (dataPoints[i].batteryLevel > dataPoints[i - 1].batteryLevel + 10) {
        numberOfCharges++;
      }
    }

    return BatteryUsageStats(
      startDate: startDate,
      endDate: endDate,
      totalEnergyConsumed: totalEnergyConsumed,
      averageEfficiency: averageEfficiency,
      numberOfCharges: numberOfCharges,
      dataPoints: dataPoints,
    );
  }

  double _getPeakPowerForType(ChargingType type) {
    switch (type) {
      case ChargingType.home:
        return 7.0 + _random.nextDouble() * 4; // 7-11 kW
      case ChargingType.public:
        return 20.0 + _random.nextDouble() * 30; // 20-50 kW
      case ChargingType.fast:
        return 100.0 + _random.nextDouble() * 50; // 100-150 kW
      case ChargingType.supercharger:
        return 150.0 + _random.nextDouble() * 100; // 150-250 kW
    }
  }

  double _getCostPerKwhForType(ChargingType type) {
    switch (type) {
      case ChargingType.home:
        return 0.12 + _random.nextDouble() * 0.08; // $0.12-0.20 per kWh
      case ChargingType.public:
        return 0.25 + _random.nextDouble() * 0.15; // $0.25-0.40 per kWh
      case ChargingType.fast:
        return 0.35 + _random.nextDouble() * 0.20; // $0.35-0.55 per kWh
      case ChargingType.supercharger:
        return 0.40 + _random.nextDouble() * 0.20; // $0.40-0.60 per kWh
    }
  }

  String _getLocationForType(ChargingType type) {
    switch (type) {
      case ChargingType.home:
        return 'Home';
      case ChargingType.public:
        final locations = [
          'Downtown Mall',
          'City Center',
          'Shopping Plaza',
          'Office Parking',
          'Public Garage',
        ];
        return locations[_random.nextInt(locations.length)];
      case ChargingType.fast:
        final locations = [
          'Highway Rest Stop',
          'Gas Station',
          'Travel Center',
          'Service Area',
        ];
        return locations[_random.nextInt(locations.length)];
      case ChargingType.supercharger:
        final locations = [
          'Tesla Supercharger Station A',
          'Tesla Supercharger Station B',
          'Tesla Supercharger Highway',
        ];
        return locations[_random.nextInt(locations.length)];
    }
  }
}
