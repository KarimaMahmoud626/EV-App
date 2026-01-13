import 'package:ev_app/features/history/presentation/view_model/cubit/history_cubit.dart';
import 'package:ev_app/features/history/presentation/view_model/cubit/history_state.dart';
import 'package:ev_app/features/history/presentation/widgets/battery_usage_graph.dart';
import 'package:ev_app/features/history/presentation/widgets/charging_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryViewBody extends StatelessWidget {
  const HistoryViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return _buildLoadingState(context);
            } else if (state is HistoryError) {
              return _buildErrorState(context, state.message);
            } else if (state is HistoryLoaded) {
              return _buildLoadedState(context, state);
            }
            return _buildLoadingState(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Loading history...',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HistoryCubit>().refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, HistoryLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<HistoryCubit>().refresh();
      },
      child: CustomScrollView(
        slivers: [
          _buildAppBar(context, state),
          _buildTimeRangeSelector(context, state),
          _buildGraph(context, state),
          _buildSectionHeader(context, 'Charging History'),
          _buildChargingHistory(context, state),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, HistoryLoaded state) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      floating: true,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      title: Text(
        'History',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context, HistoryLoaded state) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children:
              HistoryTimeRange.values.map((range) {
                final isSelected = range == state.timeRange;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _TimeRangeChip(
                      label: range.displayName,
                      isSelected: isSelected,
                      onTap: () {
                        if (!isSelected) {
                          context.read<HistoryCubit>().changeTimeRange(range);
                        }
                      },
                      colorScheme: colorScheme,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildGraph(BuildContext context, HistoryLoaded state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BatteryUsageGraph(
          dataPoints: state.batteryUsageStats.dataPoints,
          timeRange: state.timeRange.displayName,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildChargingHistory(BuildContext context, HistoryLoaded state) {
    if (state.chargingSessions.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.ev_station_outlined,
                  size: 64,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No charging sessions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'No charging sessions found for this period',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return ChargingHistoryCard(session: state.chargingSessions[index]);
        }, childCount: state.chargingSessions.length),
      ),
    );
  }
}

/// Custom chip widget for time range selection
class _TimeRangeChip extends StatelessWidget {
  const _TimeRangeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
