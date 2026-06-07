import 'package:flutter/material.dart';

/// Central place for colors, typography and component styling.
///
/// The palette is a warm cream background with a muted terracotta accent.
/// Calm and readable, nothing flashy.
class AppTheme {
  const AppTheme._();

  // Palette.
  static const Color cream = Color(0xFFF6F1E7);
  static const Color surface = Color(0xFFFFFDF8);
  static const Color terracotta = Color(0xFFC1654A);
  static const Color olive = Color(0xFF6E7A52);
  static const Color ink = Color(0xFF2E2A26);
  static const Color muted = Color(0xFF7A736B);
  static const Color hairline = Color(0xFFE6DFD2);

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: terracotta,
      onPrimary: Colors.white,
      secondary: olive,
      onSecondary: Colors.white,
      surface: surface,
      onSurface: ink,
      error: Color(0xFFB3261E),
      onError: Colors.white,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cream,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: hairline),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: cream,
        side: BorderSide(color: hairline),
        labelStyle: TextStyle(color: ink, fontSize: 12.5),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      dividerTheme: const DividerThemeData(
        color: hairline,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: ink,
        height: 1.45,
      ),
      bodySmall: base.bodySmall?.copyWith(color: muted),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
