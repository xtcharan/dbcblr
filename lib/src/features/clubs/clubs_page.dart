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
                  
                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _StatsCard(
                          title: 'Total Clubs',
                          value: departments.fold<int>(0, (sum, dept) => sum + dept.activeClubs).toString(),
                          icon: Icons.groups,
                          color: const Color(0xFFFCB900),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatsCard(
                          title: 'Active Members',
                          value: '${departments.fold<int>(0, (sum, dept) => sum + dept.totalMembers)}+',
                          icon: Icons.people,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Department Cards
                  ...departments.map((department) => 
                    DepartmentCard(
                      department: department,
                      onTap: () => _navigateToDepartmentClubs(context, department),
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

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
