import 'package:flutter/material.dart';

class AppTheme {
  static const Color accent = Color(0xFFFA5D29);
  static const Color accentHover = Color(0xFFE54D1C);
  static const Color accent2 = Color(0xFFFFF083);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: accent,
      secondary: accent2,
      surface: const Color(0xFFFAFAF7),
      onSurface: const Color(0xFF1A1A1A),
      error: danger,
    ),
    scaffoldBackgroundColor: const Color(0xFFFAFAF7),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAFAF7),
      foregroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFFFFFFF),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFDEDEDE)),
      ),
    ),
    dividerColor: const Color(0xFFDEDEDE),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.03),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.02),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF555555)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF555555)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.12, color: Color(0xFF555555)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFFFFFFF),
      selectedItemColor: accent,
      unselectedItemColor: Color(0xFF9A9A9A),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: accent,
      inactiveTrackColor: const Color(0xFFDEDEDE),
      thumbColor: const Color(0xFF1A1A1A),
      overlayColor: accent.withAlpha(25),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return const Color(0xFFA8A8A8);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return const Color(0xFFDEDEDE);
      }),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: accent,
      secondary: accent2,
      surface: const Color(0xFF0D0D0D),
      onSurface: const Color(0xFFF5F5F5),
      error: danger,
    ),
    scaffoldBackgroundColor: const Color(0xFF0D0D0D),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D0D0D),
      foregroundColor: Color(0xFFF5F5F5),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF161616),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF2A2A2A)),
      ),
    ),
    dividerColor: const Color(0xFF2A2A2A),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.03, color: Color(0xFFF5F5F5)),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.02, color: Color(0xFFF5F5F5)),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFF5F5F5)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFF5F5F5)),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFA8A8A8)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFA8A8A8)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF5F5F5)),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.12, color: Color(0xFFA8A8A8)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF161616),
      selectedItemColor: accent,
      unselectedItemColor: Color(0xFF6B6B6B),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: accent,
      inactiveTrackColor: const Color(0xFF2A2A2A),
      thumbColor: const Color(0xFFF5F5F5),
      overlayColor: accent.withAlpha(25),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return const Color(0xFF6B6B6B);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return const Color(0xFF2A2A2A);
      }),
    ),
  );
}
