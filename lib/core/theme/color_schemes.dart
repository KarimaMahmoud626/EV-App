import 'package:flutter/material.dart';

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF3DF18C),
  onPrimary: Colors.black,

  secondary: Color(0xFFBEFAD8),
  onSecondary: Colors.black,

  background: Color(0xFF0B1E1A),
  onBackground: Color(0xFFE6F5F1),

  surface: Color(0xFF112824),
  onSurface: Color(0xFFE6F5F1),

  outline: Color(0xFF2E5B53),

  error: Color(0xFFFF6B6B),
  onError: Colors.black,
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF01D5A2),
  onPrimary: Colors.white,

  secondary: Color(0xFF26A69A),
  onSecondary: Colors.white,

  background: Color(0xFFF3FBF9),
  onBackground: Color(0xFF0F2A25),

  surface: Colors.white,
  onSurface: Color(0xFF0F2A25),

  outline: Color(0xFFB2DFD6),

  error: Color(0xFFD32F2F),
  onError: Colors.white,
);
