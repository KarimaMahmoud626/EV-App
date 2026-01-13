import 'package:ev_app/features/history/data/models/battery_usage_data_point.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget that displays a battery usage graph.
///
/// Shows battery level over time with a smooth line chart.
/// Includes grid lines, labels, and interactive touch feedback.
class BatteryUsageGraph extends StatelessWidget {
  const BatteryUsageGraph({
    super.key,
    required this.dataPoints,
    required this.timeRange,
  });

  final List<BatteryUsageDataPoint> dataPoints;
  final String timeRange;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Battery Usage',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  timeRange,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                dataPoints.isEmpty
                    ? Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    )
                    : CustomPaint(
                      painter: _BatteryUsageGraphPainter(
                        dataPoints: dataPoints,
                        colorScheme: colorScheme,
                      ),
                      size: Size.infinite,
                    ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the battery usage graph
class _BatteryUsageGraphPainter extends CustomPainter {
  final List<BatteryUsageDataPoint> dataPoints;
  final ColorScheme colorScheme;

  _BatteryUsageGraphPainter({
    required this.dataPoints,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    _drawGrid(canvas, size);
    _drawYAxisLabels(canvas, size);
    _drawGraph(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = colorScheme.outline.withValues(alpha: 0.2)
          ..strokeWidth = 1;

    // Horizontal grid lines (5 lines for 0%, 25%, 50%, 75%, 100%)
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(40, y), Offset(size.width, y), paint);
    }

    // Vertical grid lines (4 lines)
    for (int i = 1; i < 4; i++) {
      final x = 40 + (size.width - 40) * (i / 4);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  void _drawYAxisLabels(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Draw percentage labels
    for (int i = 0; i <= 4; i++) {
      final percentage = 100 - (i * 25);
      final y = size.height * (i / 4);

      textPainter.text = TextSpan(
        text: '$percentage%',
        style: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.6),
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }
  }

  void _drawGraph(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    // Find min and max battery levels for scaling
    final minLevel = dataPoints.map((p) => p.batteryLevel).reduce(math.min);
    final maxLevel = dataPoints.map((p) => p.batteryLevel).reduce(math.max);
    final range = maxLevel - minLevel;
    final scaledRange = range < 20 ? 20 : range; // Minimum range of 20%

    // Calculate points
    final points = <Offset>[];
    final graphWidth = size.width - 40;

    for (int i = 0; i < dataPoints.length; i++) {
      final x = 40 + (graphWidth * i / (dataPoints.length - 1));
      final normalizedLevel =
          (dataPoints[i].batteryLevel - minLevel) / scaledRange;
      final y = size.height * (1 - normalizedLevel);
      points.add(Offset(x, y));
    }

    // Draw gradient fill
    _drawGradientFill(canvas, size, points);

    // Draw line
    _drawLine(canvas, points);

    // Draw points
    _drawPoints(canvas, points);
  }

  void _drawGradientFill(Canvas canvas, Size size, List<Offset> points) {
    final path = Path();
    path.moveTo(points.first.dx, size.height);

    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }

    path.lineTo(points.last.dx, size.height);
    path.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        colorScheme.primary.withValues(alpha: 0.3),
        colorScheme.primary.withValues(alpha: 0.05),
      ],
    );

    final paint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(0, 0, size.width, size.height),
          );

    canvas.drawPath(path, paint);
  }

  void _drawLine(Canvas canvas, List<Offset> points) {
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    // Create smooth curve using quadratic bezier
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlPoint = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        next.dx,
        next.dy,
      );
    }

    final paint =
        Paint()
          ..color = colorScheme.primary
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  void _drawPoints(Canvas canvas, List<Offset> points) {
    final paint =
        Paint()
          ..color = colorScheme.primary
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = colorScheme.surface
          ..style = PaintingStyle.fill;

    // Only draw points if there aren't too many (to avoid clutter)
    if (points.length <= 20) {
      for (final point in points) {
        // Draw white border
        canvas.drawCircle(point, 5, borderPaint);
        // Draw colored point
        canvas.drawCircle(point, 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_BatteryUsageGraphPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.colorScheme != colorScheme;
  }
}
