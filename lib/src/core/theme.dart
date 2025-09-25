import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme - White background, black text, FCB900 accent
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFCB900), // Primary Orange
      secondary: Color(0xFF757575), // Light Gray
      surface: Colors.white,
      surfaceTint: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      outline: Color(0xFFE0E0E0),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFFCB900).withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Color(0xFFFCB900), fontSize: 12, fontWeight: FontWeight.w600);
          }
          return const TextStyle(color: Colors.black54, fontSize: 12);
        },
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFFCB900), width: 2),
      ),
      hintStyle: const TextStyle(
        color: Colors.black54,
        fontSize: 16,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.urbanist().fontFamily,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.urbanist(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1A1A),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFCB900), // Primary Orange
      secondary: Color(0xFF404040), // Subtle Gray
      surface: Color(0xFF1A1A1A),
      surfaceTint: Colors.black,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      outline: Color(0xFF404040),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.black,
      indicatorColor: const Color(0xFFFCB900).withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.urbanist(
              color: const Color(0xFFFCB900),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            );
          }
          return GoogleFonts.urbanist(
            color: const Color(0xFF404040),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          );
        },
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFFCB900), width: 2),
      ),
      hintStyle: GoogleFonts.urbanist(
        color: Color(0xFF404040),
        fontSize: 16,
      ),
    ),
    textTheme: GoogleFonts.urbanistTextTheme(
      ThemeData.dark().textTheme.copyWith(
        displayLarge: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.urbanist(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.urbanist(
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.urbanist(
          color: Colors.white,
        ),
        bodySmall: GoogleFonts.urbanist(
          color: const Color(0xFF404040),
        ),
      ),
    ),
  );
}
