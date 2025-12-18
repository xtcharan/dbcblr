import 'package:flutter/material.dart';
import '../../../shared/models/user.dart';

class AcademicSection extends StatelessWidget {
  const AcademicSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.fake();

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
          // Student ID
          if (user.studentId != null)
            _row(Icons.badge, 'Student ID', user.studentId!, context),
          
          // For DBC students
          if (user.userType == UserType.student) ...[
            if (user.year != null)
              _row(Icons.school, 'Year', user.year!, context),
            if (user.semester != null)
              _row(Icons.calendar_today, 'Semester', 'Sem ${user.semester}', context),
            if (user.course != null)
              _row(Icons.menu_book, 'Course', user.course!, context),
          ],
          
          // For guest users
          if (user.userType == UserType.guest) ...[
            if (user.institutionName != null)
              _row(Icons.account_balance, 'Institution', user.institutionName!, context),
            if (user.educationLevel == EducationLevel.school) ...[
              if (user.className != null)
                _row(Icons.class_, 'Class', user.className!, context),
              if (user.section != null)
                _row(Icons.group, 'Section', user.section!, context),
            ],
            if (user.educationLevel == EducationLevel.pu) ...[
              if (user.stream != null)
                _row(Icons.science, 'Stream', user.stream!, context),
              if (user.course != null)
                _row(Icons.menu_book, 'Course', user.course!, context),
              if (user.year != null)
                _row(Icons.school, 'Year', user.year!, context),
            ],
            if (user.educationLevel == EducationLevel.college) ...[
              if (user.course != null)
                _row(Icons.menu_book, 'Course', user.course!, context),
              if (user.year != null)
                _row(Icons.school, 'Year', user.year!, context),
              if (user.semester != null)
                _row(Icons.calendar_today, 'Semester', 'Sem ${user.semester}', context),
            ],
          ],
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
