import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:ev_app/features/battery_monitoring/data/models/battery_data_model.dart';
import 'package:ev_app/features/battery_monitoring/data/repos/battery_data_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'battery_state.dart';

class BatteryCubit extends Cubit<BatteryState> {
  final BatteryDataRepo _repository;
  StreamSubscription? _subscription;

  BatteryCubit(this._repository) : super(BatteryInitial());

  void startMonitoring() {
    stopMonitoring();

    emit(const BatteryLoading());

    _subscription = _repository.getBatteryDataStream().listen(
      (data) {
        emit(BatteryMonitoring(data));
      },
      onError: (error) {
        emit(BatteryError(error.toString()));
      },
    );
  }

  void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
    emit(const BatteryStopped());
  }

  void toggleCharging() {
    if (_repository.isCharging) {
      _repository.stopCharging();
    } else {
      _repository.startCharging();
    }
  }

  void startCharging() {
    _repository.startCharging();
  }

  void stopCharging() {
    _repository.stopCharging();
  }

  bool get isCharging => _repository.isCharging;

  void refresh() {
    startMonitoring();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
