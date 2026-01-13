import 'package:equatable/equatable.dart';
import 'package:ev_app/features/history/data/models/battery_usage_data_point.dart';
import 'package:ev_app/features/history/data/models/charging_session_model.dart';

/// Base state for history feature
abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

/// Loading state while fetching history data
class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

/// Successfully loaded history data
class HistoryLoaded extends HistoryState {
  final List<ChargingSessionModel> chargingSessions;
  final BatteryUsageStats batteryUsageStats;
  final HistoryTimeRange timeRange;

  const HistoryLoaded({
    required this.chargingSessions,
    required this.batteryUsageStats,
    required this.timeRange,
  });

  @override
  List<Object?> get props => [chargingSessions, batteryUsageStats, timeRange];
}

/// Error state when data loading fails
class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Time range options for history view
enum HistoryTimeRange {
  daily,
  weekly,
  monthly;

  String get displayName {
    switch (this) {
      case HistoryTimeRange.daily:
        return 'Today';
      case HistoryTimeRange.weekly:
        return 'Week';
      case HistoryTimeRange.monthly:
        return 'Month';
    }
  }

  /// Get the start date for this time range
  DateTime getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case HistoryTimeRange.daily:
        return DateTime(now.year, now.month, now.day);
      case HistoryTimeRange.weekly:
        return now.subtract(const Duration(days: 7));
      case HistoryTimeRange.monthly:
        return now.subtract(const Duration(days: 30));
    }
  }

  /// Get the end date for this time range (now)
  DateTime getEndDate() {
    return DateTime.now();
  }
}
