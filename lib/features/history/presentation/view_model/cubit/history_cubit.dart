import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ev_app/features/history/data/datasources/history_mock_data_source.dart';
import 'package:ev_app/features/history/presentation/view_model/cubit/history_state.dart';

/// Cubit for managing history screen state.
///
/// Handles loading charging sessions and battery usage data,
/// and manages time range filtering.
class HistoryCubit extends Cubit<HistoryState> {
  final HistoryMockDataSource _dataSource;

  HistoryCubit({HistoryMockDataSource? dataSource})
    : _dataSource = dataSource ?? HistoryMockDataSource(),
      super(const HistoryInitial());

  /// Load history data for the specified time range
  Future<void> loadHistory({
    HistoryTimeRange timeRange = HistoryTimeRange.weekly,
  }) async {
    try {
      emit(const HistoryLoading());

      // Simulate network delay
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Get date range
      final startDate = timeRange.getStartDate();
      final endDate = timeRange.getEndDate();

      // Load charging sessions
      final allSessions = _dataSource.generateChargingSessions();

      // Filter sessions by time range
      final filteredSessions =
          allSessions.where((session) {
            return session.startTime.isAfter(startDate) &&
                session.startTime.isBefore(endDate);
          }).toList();

      // Load battery usage stats
      final batteryUsageStats = _dataSource.generateBatteryUsageStats(
        startDate: startDate,
        endDate: endDate,
      );

      emit(
        HistoryLoaded(
          chargingSessions: filteredSessions,
          batteryUsageStats: batteryUsageStats,
          timeRange: timeRange,
        ),
      );
    } catch (e) {
      emit(HistoryError('Failed to load history: ${e.toString()}'));
    }
  }

  /// Change the time range and reload data
  Future<void> changeTimeRange(HistoryTimeRange newTimeRange) async {
    await loadHistory(timeRange: newTimeRange);
  }

  /// Refresh current data
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is HistoryLoaded) {
      await loadHistory(timeRange: currentState.timeRange);
    } else {
      await loadHistory();
    }
  }
}
