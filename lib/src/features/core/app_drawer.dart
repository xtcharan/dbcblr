import 'package:flutter/material.dart';
import '../../shared/models/user.dart'; // for avatar + name
import '../../shared/utils/toast.dart'; // for toast notifications

class AppDrawer extends StatelessWidget {
  final int currentIndex; // which tab is active
  final Function(int) onItemTap; // callback to change tab

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = User.fake();

    return NavigationDrawer(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        Navigator.pop(context); // close drawer
        onItemTap(index); // switch tab
      },
      children: [
        // header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.houseId.toUpperCase(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () => onItemTap(4),
              ), // jump to Profile
            ],
          ),
        ),
        const Divider(),

        // destinations (same order as bottom nav)
        NavigationDrawerDestination(
          icon: const Icon(Icons.home),
          label: const Text('Home'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.event),
          label: const Text('Events'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.group_work),
          label: const Text('Clubs'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.groups),
          label: const Text('House'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.emoji_events),
          label: const Text('Achievements'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings),
          label: const Text('Settings'),
        ),
        const Divider(),

        // non-destinations (no highlight)
        ListTile(
          leading: const Icon(Icons.help_outline, color: Colors.grey),
          title: const Text('Help & Support'),
          onTap: () => _snack(context, 'Help center'),
        ),
        ListTile(
          leading: const Icon(Icons.share, color: Colors.grey),
          title: const Text('Share App'),
          onTap: () => _snack(context, 'Share sheet'),
        ),
        const Divider(),

        // red logout
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () => _logout(context),
        ),
      ],
    );
  }

  void _snack(BuildContext context, String msg) {
    Navigator.pop(context);
    showToast(msg, context: context);
  }

  void _logout(BuildContext context) {
    Navigator.pop(context);
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
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
