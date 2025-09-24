import 'package:flutter/material.dart';

class AcademicSection extends StatelessWidget {
  const AcademicSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Text(
              'Academic Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          _row(Icons.badge, 'Student ID', 'U19PD23S0007', context),
          _row(Icons.school, 'Academic Year', 'Third Year', context),
          _row(Icons.menu_book, 'Course', 'BCA - Computer Science', context),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) => BoxDecoration(
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

  Widget _row(IconData leadingIcon, String label, String value, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(leadingIcon, color: Colors.green),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey
              : Colors.grey[400],
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black87
              : Colors.white,
        ),
      ),
    );
  }
}
