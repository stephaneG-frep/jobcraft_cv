import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1D5FAD),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD7E8FF),
      onPrimaryContainer: Color(0xFF062A4F),
      secondary: Color(0xFF216869),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFD4F3F0),
      onSecondaryContainer: Color(0xFF053434),
      tertiary: Color(0xFF7A5B00),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFE08A),
      onTertiaryContainer: Color(0xFF271B00),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFF4F7FB),
      onSurface: Color(0xFF17212B),
      surfaceContainerHighest: Color(0xFFE6ECF3),
      outline: Color(0xFFB9C4D0),
      shadow: Color(0x22000000),
    );

    return _base(colorScheme).copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: _cardTheme(Colors.white, const Color(0xFFE1E8F0)),
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: Colors.white,
        borderColor: const Color(0xFFD5DEE8),
      ),
    );
  }

  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF7CC7FF),
      onPrimary: Color(0xFF00233D),
      primaryContainer: Color(0xFF123A5A),
      onPrimaryContainer: Color(0xFFD8ECFF),
      secondary: Color(0xFF7DE2D1),
      onSecondary: Color(0xFF003731),
      secondaryContainer: Color(0xFF114D48),
      onSecondaryContainer: Color(0xFFBFF5EC),
      tertiary: Color(0xFFFFD166),
      onTertiary: Color(0xFF3F2D00),
      tertiaryContainer: Color(0xFF5B4309),
      onTertiaryContainer: Color(0xFFFFE8A8),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF0B1118),
      onSurface: Color(0xFFE8EEF5),
      surfaceContainerHighest: Color(0xFF26313D),
      outline: Color(0xFF536272),
      shadow: Colors.black,
    );

    return _base(colorScheme).copyWith(
      scaffoldBackgroundColor: const Color(0xFF080D13),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF080D13),
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: _cardTheme(const Color(0xFF111A24), const Color(0xFF243242)),
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: const Color(0xFF121C27),
        borderColor: const Color(0xFF33465A),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF173446),
        labelStyle: const TextStyle(color: Color(0xFFE8F7FF)),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.28)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.tertiary,
        foregroundColor: colorScheme.onTertiary,
      ),
    );
  }

  static ThemeData _base(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.standard,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.w800, height: 1.15),
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
        titleMedium: TextStyle(fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(height: 1.35),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }

  static CardThemeData _cardTheme(Color color, Color borderColor) {
    return CardThemeData(
      elevation: 0,
      color: color,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor),
      ),
      margin: const EdgeInsets.only(bottom: 12),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: Color(0xFF7CC7FF), width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}
