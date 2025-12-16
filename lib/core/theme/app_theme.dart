import 'package:ev_app/core/theme/color_schemes.dart';
import 'package:ev_app/core/theme/app_visuals.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightColorScheme.background,
      extensions: [AppVisuals.lightVisuals],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkColorScheme.background,
      extensions: [AppVisuals.darkVisuals],
    );
  }
}
