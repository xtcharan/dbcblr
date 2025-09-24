import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1565C0),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color(0xFF1565C0),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1565C0), width: 1),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1565C0), // Blue
      secondary: Color(0xFF6A1B9A), // Violet
      surface: Colors.white,
      surfaceTint: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      outline: Color(0xFF1565C0),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFF1565C0).withValues(alpha: 0.12),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Color(0xFF1565C0), fontSize: 12);
          }
          return const TextStyle(color: Colors.black, fontSize: 12);
        },
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1565C0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1565C0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF242424),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.deepPurpleAccent,
      surface: Color(0xFF242424),
      surfaceTint: Color(0xFF121212),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: Colors.blue.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Colors.blue, fontSize: 12);
          }
          return const TextStyle(color: Colors.grey, fontSize: 12);
        },
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF1E1E1E),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    ),
  );
}
