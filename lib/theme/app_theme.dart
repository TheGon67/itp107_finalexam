import 'package:flutter/material.dart';
class AppTheme {
  static const ink = Color(0xFFFFF1D7);
  static const forest = Color(0xFFE8BB8A);
  static const teal = Color(0xFFC4D0A0);
  static const rose = Color(0xFFE9AE98);
  static const panelBottom = Color(0xFF30221C);
  static const cream = Color(0xFF3C2A22);
  static const gold = Color(0xFFF1C779);
  static const meadow = Color(0xFF201712);
  static const edge = Color(0xFF9A7350);
  static const muted = Color(0xFFD9C5AD);
  static const buttonInk = Color(0xFF2A1B13);
  static ThemeData get theme => ThemeData(
    useMaterial3: true, brightness: Brightness.dark,
    scaffoldBackgroundColor: meadow,
    colorScheme: ColorScheme.fromSeed(seedColor: forest, brightness: Brightness.dark,
      primary: forest, onPrimary: buttonInk, secondary: gold, onSecondary: buttonInk, tertiary: teal, onTertiary: buttonInk,
      surface: cream, onSurface: ink, error: const Color(0xFFFFB2A4)),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontFamily: 'QuestPixel', fontSize: 18, color: ink),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ink),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: ink),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4, color: muted),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF2D1D16), foregroundColor: ink,
      centerTitle: false, titleTextStyle: TextStyle(fontFamily: 'QuestPixel', fontSize: 17, color: ink)),
    dividerTheme: const DividerThemeData(color: Color(0xFF72533D), thickness: 1),
    iconTheme: const IconThemeData(color: forest),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: gold,
      foregroundColor: buttonInk, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2),
        side: const BorderSide(color: gold, width: 2))),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      backgroundColor: gold, foregroundColor: buttonInk,
      disabledBackgroundColor: const Color(0xFF584130), disabledForegroundColor: muted,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2), side: const BorderSide(color: edge, width: 2)))),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
      foregroundColor: forest, side: const BorderSide(color: edge),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
    inputDecorationTheme: const InputDecorationTheme(filled: true, fillColor: Color(0xFF271B15),
      labelStyle: TextStyle(color: muted),
      border: OutlineInputBorder(borderRadius: BorderRadius.zero),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: edge)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: forest, width: 2))),
    snackBarTheme: const SnackBarThemeData(backgroundColor: Color(0xFF51382A), contentTextStyle: TextStyle(color: ink)),
  );
}
