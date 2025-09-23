import 'package:flutter/material.dart';
import 'package:swo/src/features/profile/sections/academic_section.dart';
import 'package:swo/src/features/profile/sections/achievements_section.dart';
import 'package:swo/src/features/profile/sections/house_stats_section.dart';
import 'package:swo/src/features/profile/sections/my_events_section.dart';
import 'package:swo/src/features/profile/sections/notif_settings_section.dart';
import 'package:swo/src/features/profile/sections/personal_section.dart';
import 'package:swo/src/features/profile/sections/security_section.dart';
import 'sections/header_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: call backend reload later
          final messenger = ScaffoldMessenger.of(context);
          await Future.delayed(const Duration(seconds: 1)); // fake delay
          if (!mounted) return;
          messenger.showSnackBar(
            const SnackBar(content: Text('Profile refreshed')),
          );
        },
        child: ListView(
          children: const [
            ProfileHeaderSection(),
            PersonalSection(),
            AcademicSection(),
            AchievementsSection(), // Add the achievements section
            HouseStatsSection(),
            MyEventsSection(),
            NotifSettingsSection(),
            SecuritySection(),

            // green banner
            // rest of sections will be added below this
          ],
        ),
      ),
    );
  }
}
