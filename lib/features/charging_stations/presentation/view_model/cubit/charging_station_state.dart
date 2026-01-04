part of 'charging_station_cubit.dart';

sealed class ChargingStationState extends Equatable {
  const ChargingStationState();

  @override
  List<Object> get props => [];
}

final class ChargingStationInitial extends ChargingStationState {}

final class ChargingStationLoading extends ChargingStationState {}

final class ChargingStationLoaded extends ChargingStationState {
  final List<ChargingStationModel> stations;
  final LatLng userLatLng;

  const ChargingStationLoaded(this.stations, this.userLatLng);

  @override
  List<Object> get props => [stations, userLatLng];
}

final class ChargingStationEmpty extends ChargingStationState {}

final class ChargingStationFailure extends ChargingStationState {
  final String errorMessage;

  const ChargingStationFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
