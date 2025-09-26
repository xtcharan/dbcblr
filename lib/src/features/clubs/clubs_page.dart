import 'package:flutter/material.dart';
import 'data/clubs_data.dart';
import 'widgets/department_card.dart';
import 'department_clubs_page.dart';

class ClubsPage extends StatelessWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final departments = ClubsData.getDepartments();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // iPhone-style large header
          const SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFFF8F9FA),
            elevation: 0,
            automaticallyImplyLeading: false, // Remove back button
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Clubs',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              expandedTitleScale: 1.3,
            ),
          ),

          // Department Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subtitle
                  Text(
                    'Explore clubs by department and discover your passion.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Department Cards
                  ...departments.map(
                    (department) => DepartmentCard(
                      department: department,
                      onTap: () =>
                          _navigateToDepartmentClubs(context, department),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDepartmentClubs(BuildContext context, department) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepartmentClubsPage(department: department),
      ),
    );
  }
}
