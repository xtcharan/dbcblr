import 'package:flutter/material.dart';

class ThemeColors {
  // Primary accent color (same in both themes)
  static const Color primary = Color(0xFFf8ce82);
  
  // Theme-aware colors
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.white 
        : Colors.black;
  }
  
  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.white 
        : const Color(0xFF1A1A1A);
  }
  
  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.white 
        : const Color(0xFF1A1A1A);
  }
  
  static Color cardBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? const Color(0xFFE0E0E0) 
        : const Color(0xFF2A2A2A);
  }
  
  static Color text(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.black 
        : Colors.white;
  }
  
  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.black54 
        : const Color(0xFF404040);
  }
  
  static Color textTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.black38 
        : const Color(0xFF505050);
  }
  
  static Color icon(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.black54 
        : Colors.white70;
  }
  
  static Color iconSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? Colors.black38 
        : const Color(0xFF404040);
  }
  
  static Color inputBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? const Color(0xFFF5F5F5) 
        : const Color(0xFF1A1A1A);
  }
  
  static Color inputBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light 
        ? const Color(0xFFE0E0E0) 
        : const Color(0xFF2A2A2A);
  }
  
  // Primary color with opacity
  static Color primaryWithOpacity(double opacity) {
    return primary.withValues(alpha: opacity);
  }
}