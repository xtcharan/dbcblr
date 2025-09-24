import 'package:flutter/material.dart';
import '../../../shared/utils/toast.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

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
              'Security & Privacy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          _navRow(
            Icons.lock_outline,
            'Change Password',
            () => _snack(context, 'Change password screen'),
            context,
          ),
          _navRow(
            Icons.shield_outlined,
            'Privacy Settings',
            () => _snack(context, 'Privacy screen'),
            context,
          ),
          _navRow(
            Icons.devices_outlined,
            'Session Management',
            () => _snack(context, 'Active sessions'),
            context,
          ),
          const Divider(height: 24),
          // red logout button
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () => _logout(context),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ),
          const SizedBox(height: 8),
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

  Widget _navRow(IconData icon, String title, VoidCallback onTap, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black87
              : Colors.white,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black54
            : Colors.grey[300],
      ),
      onTap: onTap,
    );
  }

  void _snack(BuildContext context, String msg) =>
      showToast('$msg coming soon', context: context);

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showToast('Logged out (fake)', context: context);
              // TODO: clear tokens & push to login
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
