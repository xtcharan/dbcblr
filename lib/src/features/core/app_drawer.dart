import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/models/user.dart'; // for avatar + name
import '../../shared/utils/toast.dart'; // for toast notifications
import '../../core/theme_provider.dart'; // for theme switching
import '../profile/profile_page.dart'; // for direct profile navigation

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
        // header - clickable profile section
        InkWell(
          onTap: () {
            Navigator.pop(context); // close drawer
            // Navigate directly to ProfilePage like in HomePage
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // close drawer
                    // Navigate directly to ProfilePage like in HomePage
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    backgroundImage: user.avatarPath != null
                        ? FileImage(File(user.avatarPath!))
                        : null,
                    child: user.avatarPath == null
                        ? Icon(Icons.person, color: Theme.of(context).colorScheme.primary)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // close drawer
                      // Navigate directly to ProfilePage like in HomePage
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.light 
                                ? Colors.black 
                                : Colors.white,
                          ),
                        ),
                        Text(
                          user.houseId.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).brightness == Brightness.light 
                                ? Colors.black54 
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // close drawer
                    // Navigate directly to ProfilePage like in HomePage
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const Divider(),

        // destinations (same order as bottom nav)
        NavigationDrawerDestination(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).brightness == Brightness.light 
                ? Colors.black54 
                : Colors.white70,
          ),
          label: Text(
            'Home',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.black 
                  : Colors.white,
            ),
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(
            Icons.event,
            color: Theme.of(context).brightness == Brightness.light 
                ? Colors.black54 
                : Colors.white70,
          ),
          label: Text(
            'Events',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.black 
                  : Colors.white,
            ),
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(
            Icons.group_work,
            color: Theme.of(context).brightness == Brightness.light 
                ? Colors.black54 
                : Colors.white70,
          ),
          label: Text(
            'Clubs',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.black 
                  : Colors.white,
            ),
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(
            Icons.groups,
            color: Theme.of(context).brightness == Brightness.light 
                ? Colors.black54 
                : Colors.white70,
          ),
          label: Text(
            'House',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.black 
                  : Colors.white,
            ),
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(
            Icons.person,
            color: Theme.of(context).brightness == Brightness.light 
                ? Colors.black54 
                : Colors.white70,
          ),
          label: Text(
            'Profile',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.black 
                  : Colors.white,
            ),
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).brightness == Brightness.light 
                ? Colors.black54 
                : Colors.white70,
          ),
          label: Text(
            'Settings',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.black 
                  : Colors.white,
            ),
          ),
        ),
        const Divider(),

        // theme toggle
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return ListTile(
              leading: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light 
                      ? Colors.black 
                      : Colors.white,
                ),
              ),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                  Navigator.pop(context); // close drawer after toggle
                  showToast(
                    themeProvider.isDarkMode ? 'Switched to Dark Mode' : 'Switched to Light Mode',
                    context: context,
                  );
                },
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {
                themeProvider.toggleTheme();
                Navigator.pop(context); // close drawer after toggle
                showToast(
                  themeProvider.isDarkMode ? 'Switched to Light Mode' : 'Switched to Dark Mode',
                  context: context,
                );
              },
            );
          },
        ),
        const Divider(),

        // non-destinations (no highlight)
        ListTile(
          leading: Icon(
            Icons.help_outline,
            color: Theme.of(context).brightness == Brightness.light 
                ? Colors.black54 
                : Colors.grey,
          ),
          title: Text(
            'Help & Support',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.black 
                  : Colors.white,
            ),
          ),
          onTap: () => _snack(context, 'Help center'),
        ),
        ListTile(
          leading: Icon(
            Icons.share,
            color: Theme.of(context).brightness == Brightness.light 
                ? Colors.black54 
                : Colors.grey,
          ),
          title: Text(
            'Share App',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.black 
                  : Colors.white,
            ),
          ),
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
