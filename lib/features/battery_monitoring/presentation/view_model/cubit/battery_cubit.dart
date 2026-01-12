import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:ev_app/core/utils/app_logger.dart';
import 'package:ev_app/features/battery_monitoring/data/models/battery_data_model.dart';
import 'package:ev_app/features/battery_monitoring/data/repos/battery_data_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'battery_state.dart';

/// Manages battery monitoring state and handles battery data streaming.
///
/// This Cubit subscribes to battery data updates and manages charging operations.
/// Properly disposes of stream subscriptions to prevent memory leaks.
class BatteryCubit extends Cubit<BatteryState> {
  final BatteryDataRepo _repository;
  StreamSubscription<BatteryDataModel>? _subscription;

  BatteryCubit(this._repository) : super(BatteryInitial());

  /// Starts monitoring battery data.
  ///
  /// Cancels any existing subscription before starting a new one.
  /// Emits [BatteryLoading] initially, then [BatteryMonitoring] with data updates,
  /// or [BatteryError] if an error occurs.
  void startMonitoring() {
    AppLogger.info('Starting battery monitoring');
    stopMonitoring();

    emit(const BatteryLoading());

    _subscription = _repository.getBatteryDataStream().listen(
      (data) {
        AppLogger.debug(
          'Battery data update: SOC=${data.soc}%, Charging=${_repository.isCharging}',
        );
        emit(BatteryMonitoring(data));
      },
      onError: (error, stackTrace) {
        AppLogger.error(
          'Battery monitoring error',
          error,
          stackTrace as StackTrace,
        );
        emit(BatteryError(error.toString()));
      },
    );
  }

  /// Stops monitoring battery data.
  ///
  /// Cancels the stream subscription and emits [BatteryStopped].
  void stopMonitoring() {
    if (_subscription != null) {
      AppLogger.info('Stopping battery monitoring');
      _subscription?.cancel();
      _subscription = null;
      emit(const BatteryStopped());
    }
  }

  /// Toggles charging state (start if stopped, stop if started).
  void toggleCharging() {
    if (_repository.isCharging) {
      AppLogger.info('Stopping charging');
      _repository.stopCharging();
    } else {
      AppLogger.info('Starting charging');
      _repository.startCharging();
    }
  }

  /// Starts battery charging.
  void startCharging() {
    AppLogger.info('Starting charging');
    _repository.startCharging();
  }

  /// Stops battery charging.
  void stopCharging() {
    AppLogger.info('Stopping charging');
    _repository.stopCharging();
  }

  /// Returns whether the battery is currently charging.
  bool get isCharging => _repository.isCharging;

  /// Refreshes battery monitoring by restarting the stream.
  void refresh() {
    AppLogger.info('Refreshing battery monitoring');
    startMonitoring();
  }

  @override
  Future<void> close() {
    AppLogger.debug('Closing BatteryCubit and canceling subscriptions');
    _subscription?.cancel();
    return super.close();
  }
}
