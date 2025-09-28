import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'data/clubs_data.dart';
import 'models/club.dart';
import '../../shared/utils/theme_colors.dart';
import '../../core/theme_provider.dart';

class ClubDetailPage extends StatefulWidget {
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
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Sample announcements data
  final List<Map<String, dynamic>> _announcements = [
    {
      'title': 'Hackathon 2025 Registration Open!',
      'content': 'Exciting news! Registration for our annual Hackathon 2025 is now open. Join us for 48 hours of coding, innovation, and networking. Prizes worth ₹50,000 await!',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'important': true,
    },
    {
      'title': 'Weekly Tech Talk - AI & Machine Learning',
      'content': 'Join us this Friday for an insightful tech talk on AI and Machine Learning fundamentals. Industry expert will share practical insights.',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'important': false,
    },
    {
      'title': 'Club Meeting - Project Showcase Planning',
      'content': 'All members are invited to attend our planning meeting for the upcoming project showcase. We will discuss presentation formats and timelines.',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'important': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Find the club from our data
    final departments = ClubsData.getDepartments();
    final department = departments.firstWhere(
      (dept) => dept.code == widget.departmentCode,
      orElse: () => departments.first,
    );
    
    final club = department.clubs.firstWhere(
      (c) => c.name == widget.clubName,
      orElse: () => department.clubs.first,
    );

    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Compact Header with Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: ThemeColors.surface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ThemeColors.cardBorder(context),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ThemeColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Title
                  Expanded(
                    child: Text(
                      club.shortName,
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.text(context),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Theme Toggle Button
                  GestureDetector(
                    onTap: () {
                      context.read<ThemeProvider>().toggleTheme();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: ThemeColors.surface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ThemeColors.cardBorder(context),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Theme.of(context).brightness == Brightness.light
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: ThemeColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Club Header Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    club.primaryColor,
                    club.primaryColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: club.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      club.icon,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club.tagline,
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _HeaderStat('${club.memberCount}', 'Members'),
                            const SizedBox(width: 20),
                            _HeaderStat('${club.upcomingEventsCount}', 'Events'),
                            const SizedBox(width: 20),
                            _HeaderStat('${club.rating}★', 'Rating'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tab Navigation
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: ThemeColors.surface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  _buildTabButton('Announcements', 0, Icons.campaign),
                  _buildTabButton('Events', 1, Icons.event),
                  _buildTabButton('Club Info', 2, Icons.info),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tab Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  _buildAnnouncementsTab(club),
                  _buildEventsTab(club),
                  _buildClubInfoTab(club),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ThemeColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : ThemeColors.iconSecondary(context),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black : ThemeColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementsTab(Club club) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ..._announcements.map((announcement) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeColors.cardBackground(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: announcement['important'] 
                    ? ThemeColors.primary.withValues(alpha: 0.3)
                    : ThemeColors.cardBorder(context),
                width: announcement['important'] ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.cardBorder(context).withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (announcement['important'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ThemeColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'IMPORTANT',
                          style: GoogleFonts.urbanist(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.primary,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Text(
                      _formatAnnouncementDate(announcement['date']),
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: ThemeColors.textTertiary(context),
                      ),
                    ),
                  ],
                ),
                if (announcement['important']) const SizedBox(height: 12),
                Text(
                  announcement['title'],
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  announcement['content'],
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: ThemeColors.textSecondary(context),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEventsTab(Club club) {
    final upcomingEvents = club.upcomingEvents;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (upcomingEvents.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: ThemeColors.cardBackground(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 48,
                    color: ThemeColors.iconSecondary(context),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Upcoming Events',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.text(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay tuned for exciting events coming soon!',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: ThemeColors.textSecondary(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...upcomingEvents.map((event) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ThemeColors.cardBackground(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.cardBorder(context).withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: club.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.event,
                          color: club.primaryColor,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.title,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.text(context),
                          ),
                        ),
                      ),
                      if (event.isRegistrationOpen)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'OPEN',
                            style: GoogleFonts.urbanist(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: ThemeColors.textSecondary(context),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: ThemeColors.iconSecondary(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.time,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: ThemeColors.textTertiary(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: ThemeColors.iconSecondary(context),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: ThemeColors.textTertiary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildClubInfoTab(Club club) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leadership Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeColors.cardBackground(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ThemeColors.cardBorder(context),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.cardBorder(context).withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.groups,
                      color: club.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Leadership Team',
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.text(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...club.leadership.map((leader) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: club.primaryColor.withValues(alpha: 0.1),
                        child: Text(
                          leader.name.split(' ').map((n) => n[0]).take(2).join(),
                          style: GoogleFonts.urbanist(
                            color: club.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              leader.name,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ThemeColors.text(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              leader.role,
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: ThemeColors.textSecondary(context),
                              ),
                            ),
                            if (leader.email != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                leader.email!,
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: ThemeColors.textTertiary(context),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // About Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThemeColors.cardBackground(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ThemeColors.cardBorder(context),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.cardBorder(context).withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About ${club.shortName}',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  club.description,
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: ThemeColors.textSecondary(context),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Specializations',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.text(context),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: club.specializations.map((spec) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: club.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      spec,
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: club.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _formatAnnouncementDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inHours;
    
    if (diff < 1) return 'Just now';
    if (diff < 24) return '$diff hours ago';
    
    final dayDiff = now.difference(date).inDays;
    if (dayDiff == 1) return 'Yesterday';
    if (dayDiff < 7) return '$dayDiff days ago';
    
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeaderStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.urbanist(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
