import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_colors.dart';

class FontUtils {
  static TextStyle urbanist({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    required BuildContext context,
  }) {
    try {
      return GoogleFonts.urbanist(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? ThemeColors.text(context),
      );
    } catch (e) {
      // Fallback to system font if Google Fonts fails
      return TextStyle(
        fontFamily: 'sans-serif', // Android system font
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? ThemeColors.text(context),
      );
    }
  }

  static TextStyle urbanistSafe({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    required BuildContext context,
  }) {
    // Use system fonts directly to avoid network requests
    return TextStyle(
      fontFamily: 'Roboto', // Default Android font
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? ThemeColors.text(context),
    );
  }
}
