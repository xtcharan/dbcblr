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
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 12),
            child: Text(
              'Personal Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withValues(alpha: 0.08),
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
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      subtitle: Text(value, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.edit_outlined, color: Colors.grey),
      onTap: () => showToast('Edit $label coming soon'),
    );
  }
}
