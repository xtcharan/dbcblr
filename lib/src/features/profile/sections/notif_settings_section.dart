import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotifSettingsSection extends StatefulWidget {
  const NotifSettingsSection({super.key});

  @override
  State<NotifSettingsSection> createState() => _NotifSettingsSectionState();
}

class _NotifSettingsSectionState extends State<NotifSettingsSection> {
  bool push = true;
  bool email = true;
  bool reminders = true;
  bool houseUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 12),
            child: Text(
              'Notification Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _toggle(
            'Push Notifications',
            Icons.notifications,
            push,
            (v) => setState(() => push = v),
          ),
          _toggle(
            'Email Notifications',
            Icons.email,
            email,
            (v) => setState(() => email = v),
          ),
          _toggle(
            'Event Reminders',
            Icons.access_time,
            reminders,
            (v) => setState(() => reminders = v),
          ),
          _toggle(
            'House Updates',
            Icons.home,
            houseUpdates,
            (v) => setState(() => houseUpdates = v),
          ),
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

  Widget _toggle(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Switch(
        value: value,
        onChanged: (v) {
          HapticFeedback.lightImpact(); // nice click feel
          onChanged(v);
        },
        activeThumbColor: Colors.green, // replaces deprecated activeColor
      ),
    );
  }
}
