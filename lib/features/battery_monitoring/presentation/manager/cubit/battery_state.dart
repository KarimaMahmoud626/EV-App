part of 'battery_cubit.dart';

sealed class BatteryState extends Equatable {
  const BatteryState();

  @override
  List<Object> get props => [];
}

final class BatteryInitial extends BatteryState {}

class BatteryLoading extends BatteryState {
  const BatteryLoading();
}

class BatteryMonitoring extends BatteryState {
  final BatteryDataModel data;

  const BatteryMonitoring(this.data);

  bool get isCharging => data.current > 0;
  bool get isLowBattery => data.soc < 20;
  bool get isHealthy => data.soh > 70;

  @override
  List<Object> get props => [data];
}

class BatteryError extends BatteryState {
  final String message;

  const BatteryError(this.message);

  @override
  List<Object> get props => [message];
}

class BatteryStopped extends BatteryState {
  const BatteryStopped();
}
