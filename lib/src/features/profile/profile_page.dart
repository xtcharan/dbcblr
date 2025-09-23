// Backend endpoints we will build:
// GET /me               → returns User JSON
// POST /logout          → clears cookie/token

import 'package:flutter/material.dart';
import '../../shared/models/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.fake(); // will be fetched later

    final houseColour = _houseColor(user.houseId);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // avatar + name
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(height: 12),
            Text(
              '${user.firstName} ${user.lastName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(user.email, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 24),

            // house badge
            ListTile(
              leading: Icon(Icons.groups, color: houseColour),
              title: const Text('House'),
              subtitle: Text(user.houseId.toUpperCase()),
              trailing: Chip(
                backgroundColor: houseColour,
                label: Text('1 250 pts', style: TextStyle(color: Colors.white)),
              ),
            ),

            const Spacer(),

            // logout button (does nothing yet)
            FilledButton.tonalIcon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Color _houseColor(String id) {
    switch (id) {
      case 'ruby':
        return Colors.red;
      case 'sapphire':
        return Colors.blue;
      case 'topaz':
        return Colors.amber;
      case 'emerald':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _logout(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logout not wired yet')));
  }
}
