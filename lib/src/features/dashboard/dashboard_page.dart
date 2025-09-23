import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../events/events_page.dart';
import '../clubs/clubs_page.dart';
import '../house/house_page.dart';
import '../profile/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _current = 0; // start on Home

  final _pages = const [
    HomePage(), // 0
    EventsPage(), // 1
    ClubsPage(), // 2
    HousePage(), // 3
    ProfilePage(), // 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_current],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _current,
        onDestinationSelected: (i) => setState(() => _current = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.group_work), label: 'Clubs'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'House'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
