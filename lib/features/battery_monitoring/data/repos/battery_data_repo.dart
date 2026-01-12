import 'package:ev_app/features/battery_monitoring/data/models/battery_data_model.dart';

/// Abstract repository for battery monitoring operations.
///
/// Defines the contract for battery data operations.
abstract class BatteryDataRepo {
  /// Gets a stream of battery data updates.
  ///
  /// Emits [BatteryDataModel] periodically with current battery status.
  Stream<BatteryDataModel> getBatteryDataStream();

  /// Starts the battery charging process.
  void startCharging();

  /// Stops the battery charging process.
  void stopCharging();

  /// Returns whether the battery is currently charging.
  bool get isCharging;

  /// Gets the current battery data as a one-time value.
  ///
  /// Returns the current [BatteryDataModel] snapshot.
  Future<BatteryDataModel> getCurrentBatteryData();
}
