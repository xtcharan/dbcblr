import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../events/events_page.dart';
import '../clubs/clubs_page.dart';
import '../house/house_page.dart';
import '../profile/profile_page.dart';
import '../sports/sports_page.dart';
import '../../features/core/app_drawer.dart'; // NEW

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _current = 0; // which tab active

  void _onDrawerTap(int index) {
    if (index <= 4) {
      // bottom-nav indices
      setState(() => _current = index);
    } else if (index == 5) {
      // Profile page (not in bottom nav)
      setState(() => _current = 5);
    } else if (index == 6) {
      // Settings deep-link
      setState(() => _current = 5); // open Profile tab
      // TODO: scroll to settings section
    }
  }

  final _pages = [
    HomePage(), // 0
    EventsPage(), // 1
    ClubsPage(), // 2
    HousePage(), // 3
    SportsPage(), // 4
    ProfilePage(), // 5 (not in navigation bar, but accessible from drawer)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NEW: drawer
      drawer: AppDrawer(currentIndex: _current, onItemTap: _onDrawerTap),
      // existing bottom nav stays
      body: _pages[_current],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _current,
        onDestinationSelected: (i) => setState(() => _current = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
          NavigationDestination(icon: Icon(Icons.group_work), label: 'Clubs'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'House'),
          NavigationDestination(icon: Icon(Icons.sports), label: 'Sports'),
        ],
      ),
    );
  }
}
