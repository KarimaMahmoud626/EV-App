import 'package:ev_app/features/history/data/models/charging_session_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget that displays a single charging session card.
///
/// Shows session details including time, location, energy, cost, and charging type.
/// Uses different colors for different charging types while maintaining design consistency.
class ChargingHistoryCard extends StatelessWidget {
  const ChargingHistoryCard({
    super.key,
    required this.session,
  });

  final ChargingSessionModel session;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = _getCardColor(session.chargingType, colorScheme);
    final accentColor = _getAccentColor(session.chargingType, colorScheme);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: accentColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, accentColor),
              const SizedBox(height: 12),
              _buildStats(context, colorScheme),
              const SizedBox(height: 12),
              _buildFooter(context, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color accentColor) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Charging type icon
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getIconForType(session.chargingType),
            color: accentColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        // Location and type
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session.location,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                session.chargingType.displayName,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        // Cost
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${session.cost.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildStatItem(
            context,
            icon: Icons.bolt,
            label: 'Energy',
            value: '${session.energyAdded.toStringAsFixed(1)} kWh',
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            context,
            icon: Icons.battery_charging_full,
            label: 'SOC',
            value: '${session.startSoc.toInt()}% → ${session.endSoc.toInt()}%',
          ),
          const SizedBox(width: 16),
          _buildStatItem(
            context,
            icon: Icons.timer_outlined,
            label: 'Duration',
            value: _formatDuration(session.duration),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('h:mm a');

    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Text(
          dateFormat.format(session.startTime),
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.access_time,
          size: 14,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Text(
          '${timeFormat.format(session.startTime)} - ${timeFormat.format(session.endTime)}',
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Color _getCardColor(ChargingType type, ColorScheme colorScheme) {
    // Use surface color as base for all cards
    return colorScheme.surface;
  }

  Color _getAccentColor(ChargingType type, ColorScheme colorScheme) {
    switch (type) {
      case ChargingType.home:
        return const Color(0xFF4CAF50); // Green
      case ChargingType.public:
        return const Color(0xFF2196F3); // Blue
      case ChargingType.fast:
        return const Color(0xFFFF9800); // Orange
      case ChargingType.supercharger:
        return const Color(0xFFE91E63); // Pink
    }
  }

  IconData _getIconForType(ChargingType type) {
    switch (type) {
      case ChargingType.home:
        return Icons.home;
      case ChargingType.public:
        return Icons.ev_station;
      case ChargingType.fast:
        return Icons.flash_on;
      case ChargingType.supercharger:
        return Icons.bolt;
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
