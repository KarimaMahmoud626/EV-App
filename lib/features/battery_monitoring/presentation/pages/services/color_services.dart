import 'package:flutter/material.dart';

class ColorServices {
  List<BoxShadow> circularShadow(ColorScheme colors) {
    final isDark = colors.brightness == Brightness.dark;

    if (isDark) {
      // Dark mode → subtle glow + depth
      return [
        BoxShadow(
          color: colors.primary.withOpacity(0.18),
          blurRadius: 50,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ];
    } else {
      // Light mode → clean & elegant shadow
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 25,
          offset: const Offset(0, 12),
        ),
      ];
    }
  }

  List<Color> progressGradient(ColorScheme colors) {
    final isDark = colors.brightness == Brightness.dark;

    if (isDark) {
      return [
        colors.primary.withOpacity(0.6),
        colors.primary,
        const Color(0xFF6BFFD2),
      ];
    } else {
      return [
        colors.primary,
        colors.secondary,
        colors.primary.withOpacity(0.7),
      ];
    }
  }

  LinearGradient sohGradient(ColorScheme colors, double value) {
    // 0.0 → 0.4 : error only
    if (value <= 0.25) {
      return LinearGradient(colors: [colors.error, colors.error]);
    }

    // 0.4 → 0.7 : error → primary
    if (value <= 0.7) {
      final t = (value - 0.25) / (0.7 - 0.25); // 0 → 1

      final blended = Color.lerp(colors.error, colors.primary, t)!;

      return LinearGradient(
        colors: [colors.error, blended, colors.primary],
        stops: const [0.0, 0.5, 1.0],
      );
    }

    // 0.7 → 1.0 : primary gradient (lighter → stronger)
    final t = (value - 0.7) / (1.0 - 0.7); // 0 → 1

    final blended = Color.lerp(colors.error, colors.primary, t)!;

    return LinearGradient(
      colors: [colors.error, blended, colors.primary],
      stops: [0.0, 0.25, 1.0],
    );
  }

  Color getSOCColor(ColorScheme colors, double soc) {
    if (soc > 60) return colors.primary; // Green
    if (soc > 20) return Color(0xFFFFA726); // Orange
    return colors.error; // Red
  }
}
