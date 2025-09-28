import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../events/events_page.dart';
import '../clubs/clubs_page.dart';
import '../house/house_page.dart';
import '../profile/profile_page.dart';
import '../announcements/announcements_page.dart';
import '../../features/core/app_drawer.dart'; // NEW

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _current = 0; // Start with Discover tab (position 0) active

  // Mapping navigation index to actual page index
  int _getPageIndex(int navIndex) {
    switch (navIndex) {
      case 0: // Discover (Home)
        return 0;
      case 1: // Events
        return 1;
      case 2: // Announcements
        return 2;
      case 3: // Clubs  
        return 3;
      case 4: // House
        return 4;
      case 5: // Profile (from drawer)
        return 5;
      default:
        return 0;
    }
  }

  void _onDrawerTap(int index) {
    // Map drawer indices to navigation indices
    switch (index) {
      case 0: // Home (Discover) - now at position 0 in nav
        setState(() => _current = 0);
        break;
      case 1: // Events - now at position 1 in nav
        setState(() => _current = 1);
        break;
      case 2: // Announcements - now at position 2 in nav
        setState(() => _current = 2);
        break;
      case 3: // Clubs - now at position 3 in nav
        setState(() => _current = 3);
        break;
      case 4: // House - now at position 4 in nav
        setState(() => _current = 4);
        break;
      case 5: // Profile page (not in bottom nav)
        setState(() => _current = 5);
        break;
      case 6: // Settings deep-link
        setState(() => _current = 5); // open Profile tab
        // TODO: scroll to settings section
        break;
    }
  }

  final _pages = [
    HomePage(), // 0 - Home/Discover
    EventsPage(), // 1 - Events
    AnnouncementsPage(), // 2 - Announcements
    ClubsPage(), // 3 - Clubs
    HousePage(), // 4 - House
    ProfilePage(), // 5 - Profile (accessible from drawer)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NEW: drawer
      drawer: AppDrawer(currentIndex: _current, onItemTap: _onDrawerTap),
      // existing bottom nav stays
      body: _pages[_getPageIndex(_current)],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          // Regular navigation bar with all 5 items (including announcements in center)
          NavigationBar(
            selectedIndex: _current,
            onDestinationSelected: (i) => setState(() => _current = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Discover'),
              NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
              NavigationDestination(icon: SizedBox.shrink(), label: ''), // Invisible placeholder for announcements
              NavigationDestination(icon: Icon(Icons.group_work), label: 'Clubs'),
              NavigationDestination(icon: Icon(Icons.groups), label: 'House'),
            ],
          ),
          // Floating announcements button
          Positioned(
            top: -10, // Brought down even closer to navigation bar
            left: MediaQuery.of(context).size.width * 0.5 - 30, // Centered horizontally
            child: GestureDetector(
              onTap: () => setState(() => _current = 2), // Set to announcements page
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light 
                        ? Colors.black 
                        : Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.campaign,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
