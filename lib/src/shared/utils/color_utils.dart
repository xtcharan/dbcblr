import 'package:flutter/material.dart';

extension ColorUtils on Color {
  /// Get the red component as an integer (0-255)
  int get redInt => (r * 255.0).round() & 0xff;

  /// Get the green component as an integer (0-255)
  int get greenInt => (g * 255.0).round() & 0xff;

  /// Get the blue component as an integer (0-255)
  int get blueInt => (b * 255.0).round() & 0xff;

  /// Create a new color with the same RGB values but with a different opacity
  Color withOpacityValue(double opacity) {
    return Color.fromRGBO(redInt, greenInt, blueInt, opacity);
  }
}
