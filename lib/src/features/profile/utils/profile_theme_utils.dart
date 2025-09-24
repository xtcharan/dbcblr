import 'package:flutter/material.dart';

class ProfileThemeUtils {
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF242424),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.2),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static Color titleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;
  }

  static Color subtitleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black87
        : Colors.white;
  }

  static Color labelColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.grey
        : Colors.grey[400]!;
  }

  static TextStyle titleTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: titleColor(context),
    );
  }

  static TextStyle labelTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 13,
      color: labelColor(context),
    );
  }

  static TextStyle valueTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      color: subtitleColor(context),
    );
  }
}