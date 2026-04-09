import 'package:flutter/material.dart';

// Palette — keep in sync with task_badges.dart constants
const _kPurple = Color(0xFF7C4DFF);
const _kBgDark = Color(0xFF0F0F1A);
const _kCardBg = Color(0xFF1A1A2E);

final appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _kBgDark,
  colorScheme: const ColorScheme.dark(
    primary: _kPurple,
    secondary: _kPurple,
    surface: _kCardBg,
  ),
  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: _kBgDark,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
  ),
  // Input fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _kCardBg,
    hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.white12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kPurple, width: 1.5),
    ),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  // Elevated buttons (Save task, Save changes, Edit task)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _kPurple,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
  ),
  // Text buttons (Save link in AppBar, Cancel in dialog)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: _kPurple),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF1A1040),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
  // FloatingActionButton
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _kPurple,
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  ),
);
