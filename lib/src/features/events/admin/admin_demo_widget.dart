import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/utils/theme_colors.dart';

class AdminDemoWidget extends StatelessWidget {
  const AdminDemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.admin_panel_settings,
            color: ThemeColors.primary,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            'Admin Mode Active',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ThemeColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can now create, edit, and delete events.',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: ThemeColors.text(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '• Tap the "Create Event" button to add new events\n'
            '• Long press or tap the ⋮ menu on event cards to edit/delete\n'
            '• All forms include comprehensive validation',
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: ThemeColors.textSecondary(context),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}