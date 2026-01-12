import 'package:ev_app/core/services/battery_data_simulator.dart';
import 'package:ev_app/features/battery_monitoring/data/models/battery_data_model.dart';
import 'package:ev_app/features/battery_monitoring/data/repos/battery_data_repo.dart';

/// Implementation of [BatteryDataRepo] that uses a simulator for battery data.
///
/// In a real application, this would connect to actual battery hardware/API.
class BatteryDataRepoImpl implements BatteryDataRepo {
  final BatteryDataSimulator simulator;

  BatteryDataRepoImpl(this.simulator);

  @override
  Stream<BatteryDataModel> getBatteryDataStream() {
    return simulator.getBatteryDataStream();
  }

  @override
  void startCharging() {
    simulator.startCharging();
  }

  @override
  void stopCharging() {
    simulator.stopCharging();
  }

  @override
  bool get isCharging => simulator.isCharging;

  @override
  Future<BatteryDataModel> getCurrentBatteryData() async {
    final data = await simulator.getBatteryDataStream().first;
    return data;
  }
}
