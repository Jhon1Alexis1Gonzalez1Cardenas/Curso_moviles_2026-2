import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        colorSchemeSeed: const Color(0xFF0B3D91),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      );
}
