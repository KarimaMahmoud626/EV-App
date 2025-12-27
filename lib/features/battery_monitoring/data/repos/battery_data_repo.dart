import 'package:ev_app/core/services/battery_data_simulator.dart';
import 'package:ev_app/features/battery_monitoring/data/models/battery_data_model.dart';

class BatteryDataRepo {
  final BatteryDataSimulator simulator;

  const BatteryDataRepo(this.simulator);

  Stream<BatteryDataModel> getBatteryDataStream() {
    return simulator.getBatteryDataStream();
  }

  void startCharging() {
    simulator.startCharging();
  }

  void stopCharging() {
    simulator.stopCharging();
  }

  bool get isCharging => simulator.isCharging;

  Future<BatteryDataModel> getCurrentBatteryData() async {
    final data = await simulator.getBatteryDataStream().first;
    return data;
  }
}
