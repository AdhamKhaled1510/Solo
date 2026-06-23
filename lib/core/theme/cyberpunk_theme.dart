import 'package:flutter/material.dart';

class CyberColors {
  static const bg = Color(0xFF0A0A0A);
  static const surface = Color(0xFF111111);
  static const card = Color(0xFF1A1A2E);
  static const neonCyan = Color(0xFF00F0FF);
  static const hotMagenta = Color(0xFFFF2A5F);
  static const amberGold = Color(0xFFFFD700);
  static const darkTeal = Color(0xFF004D4D);
  static const dimCyan = Color(0xFF008080);
  static const gridLine = Color(0xFF00F0FF);
  static const textPrimary = Color(0xFFE0E0E0);
  static const textDim = Color(0xFF707070);
  static const progressEmpty = Color(0xFF2A2A3E);

  static const cyanGradient = LinearGradient(colors: [Color(0xFF00F0FF), Color(0xFF0088CC)]);
  static const magentaGradient = LinearGradient(colors: [Color(0xFFFF2A5F), Color(0xFFCC0044)]);
  static const goldGradient = LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF8C00)]);
}

class CyberpunkTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CyberColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: CyberColors.neonCyan,
      secondary: CyberColors.hotMagenta,
      surface: CyberColors.surface,
      error: CyberColors.hotMagenta,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: CyberColors.textPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: CyberColors.neonCyan,
      unselectedItemColor: CyberColors.textDim,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: CyberColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: CyberColors.dimCyan, width: 0.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CyberColors.neonCyan,
        foregroundColor: CyberColors.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontFamily: 'monospace', color: CyberColors.neonCyan),
      titleMedium: TextStyle(fontFamily: 'monospace', color: CyberColors.textPrimary),
      bodyLarge: TextStyle(fontFamily: 'monospace', color: CyberColors.textPrimary),
      bodyMedium: TextStyle(fontFamily: 'monospace', color: CyberColors.textPrimary),
      bodySmall: TextStyle(fontFamily: 'monospace', color: CyberColors.textDim),
      labelLarge: TextStyle(fontFamily: 'monospace', color: CyberColors.neonCyan),
    ),
  );
}
