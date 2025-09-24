import 'package:flutter/material.dart';
import 'utils/club_data.dart';
import 'widgets/club_banner.dart';
import 'widgets/club_stats.dart';
import 'widgets/club_events.dart';
import 'widgets/club_activities.dart';
import 'widgets/club_leadership.dart';

class ClubDetailPage extends StatelessWidget {
  final String departmentCode;
  final String clubName;
  final IconData icon;

  const ClubDetailPage({
    super.key,
    required this.departmentCode,
    required this.clubName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final clubData = ClubData.getClubData(departmentCode);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(clubName),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ClubBanner(clubData: clubData, departmentCode: departmentCode),
          ClubStats(clubData: clubData),
          ClubEvents(clubData: clubData, departmentCode: departmentCode),
          ClubActivities(clubData: clubData),
          ClubLeadership(clubData: clubData),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
