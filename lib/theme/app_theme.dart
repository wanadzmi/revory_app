import 'package:flutter/material.dart';

/// Shared App Store-inspired theme used by both platform appearances.
ThemeData appTheme(Brightness brightness) => ThemeData(
  useMaterial3: true,
  brightness: brightness,
  colorScheme: ColorScheme.fromSeed(
    seedColor: brightness == Brightness.light
        ? const Color(0xff007aff)
        : const Color(0xff0a84ff),
    brightness: brightness,
  ),
  scaffoldBackgroundColor: brightness == Brightness.light
      ? const Color(0xfff2f2f7)
      : Colors.black,
  cardTheme: CardThemeData(
    elevation: 0,
    color: brightness == Brightness.light
        ? Colors.white
        : const Color(0xff1c1c1e),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: brightness == Brightness.light
        ? Colors.white
        : const Color(0xff1c1c1e),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: brightness == Brightness.light
        ? Colors.white
        : const Color(0xff1c1c1e),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: brightness == Brightness.light
        ? Colors.white
        : const Color(0xff1c1c1e),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: brightness == Brightness.light
        ? const Color(0xfff7f7f7)
        : const Color(0xff2c2c2e),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  ),
);
