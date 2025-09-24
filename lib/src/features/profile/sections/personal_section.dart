import 'package:flutter/material.dart';
import '../../../shared/utils/toast.dart';
import '../../../shared/models/user.dart'; // fake user for now

class PersonalSection extends StatelessWidget {
  const PersonalSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.fake();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          _row(
            Icons.person,
            'Full Name',
            '${user.firstName} ${user.lastName}',
            context,
          ),
          _row(Icons.email, 'Email Address', user.email, context),
          _row(
            Icons.phone,
            'Phone Number',
            '+91 98765 43210',
            context,
          ), // static for now
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

  Widget _row(
    IconData leadingIcon,
    String label,
    String value,
    BuildContext context,
  ) {
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
      trailing: Icon(
        Icons.edit_outlined,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey
            : Colors.grey[400],
      ),
      onTap: () => showToast('Edit $label coming soon'),
    );
  }
}
