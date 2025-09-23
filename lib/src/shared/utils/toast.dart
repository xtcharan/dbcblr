import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Shows a short toast message.
///
/// If [context] is provided, uses Material's SnackBar via ScaffoldMessenger.
/// Otherwise falls back to fluttertoast.
///
/// This method is designed to be safely used in both sync and async contexts
/// without requiring `await`. Errors are caught and logged.
void showToast(String msg, {BuildContext? context}) {
  // Use a "fire and forget" pattern for this utility function
  _showToastImpl(msg, context: context);
}

Future<void> _showToastImpl(String msg, {BuildContext? context}) async {
  try {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }

    try {
      await Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14,
      );
    } catch (e) {
      // Just log and re-throw - we'll catch in the outer try/catch
      debugPrint('Fluttertoast plugin error: $e');
      rethrow;
    }
  } catch (e, st) {
    // Don't let toast failures crash the app; log for diagnostics.
    debugPrint('⚠️ showToast failed: $e');
    debugPrint('Stack: $st');
  }
}
