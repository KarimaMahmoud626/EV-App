import 'package:flutter/material.dart';

@immutable
class AppVisuals extends ThemeExtension<AppVisuals> {
  final Color chartPrimary;
  final Color chartSecondary;
  final Color mapMarker;
  final Color glow;

  const AppVisuals({
    required this.chartPrimary,
    required this.chartSecondary,
    required this.mapMarker,
    required this.glow,
  });

  @override
  ThemeExtension<AppVisuals> copyWith({
    Color? chartPrimary,
    Color? chartSecondary,
    Color? mapMaker,
    Color? glow,
  }) {
    return AppVisuals(
      chartPrimary: chartPrimary ?? this.chartPrimary,
      chartSecondary: chartSecondary ?? this.chartSecondary,
      mapMarker: mapMarker,
      glow: glow ?? this.glow,
    );
  }

  @override
  ThemeExtension<AppVisuals> lerp(
    covariant ThemeExtension<AppVisuals>? other,
    double t,
  ) => this;

  static const darkVisuals = AppVisuals(
    chartPrimary: Color(0xFF00E5C1),
    chartSecondary: Color(0xFF4DD0E1),
    mapMarker: Color(0xFF00FFC6),
    glow: Color(0xFF00E5C1),
  );

  static const lightVisuals = AppVisuals(
    chartPrimary: Color(0xFF009688),
    chartSecondary: Color(0xFF4DB6AC),
    mapMarker: Color(0xFF00BFA5),
    glow: Color(0x3300BFA5),
  );
}
