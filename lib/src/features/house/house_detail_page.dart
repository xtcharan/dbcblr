import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../shared/models/house.dart';
import '../../shared/models/activity.dart';
import '../../shared/utils/theme_colors.dart';
import '../../core/theme_provider.dart';

class HouseDetailPage extends StatefulWidget {
  final House house;

  const HouseDetailPage({
    super.key,
    required this.house,
  });

  @override
  State<HouseDetailPage> createState() => _HouseDetailPageState();
}

class _HouseDetailPageState extends State<HouseDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final houseColor = Color(
      int.parse(widget.house.colorHex.substring(1), radix: 16) + 0xFF000000,
    );

    // Sample category breakdown data
    final categoryPoints = {
      'Sports': 520,
      'Academic': 380,
      'Cultural': 240,
      'Community': 180,
    };

    final activities = Activity.fakeFeed()
        .where((a) => a.house.toLowerCase() == widget.house.name.split(' ').first.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildHeader(context, houseColor),
            
            // Navigation Tabs
            _buildTabBar(context, houseColor),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Stats Tab
                  _buildStatsTab(context, houseColor, categoryPoints, activities),
                  
                  // Announcements Tab
                  _buildAnnouncementsTab(context, houseColor),
                  
                  // Events Tab
                  _buildEventsTab(context, houseColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color houseColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            houseColor.withValues(alpha: 0.1),
            houseColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeColors.surface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: ThemeColors.text(context),
                size: 18,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // House info
          Text(
            widget.house.mascot,
            style: const TextStyle(fontSize: 32),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.house.name,
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.house.points} Total Points',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: ThemeColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          
          // Theme toggle
          GestureDetector(
            onTap: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            child: Container(
              width: 40,
              height: 40,
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
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar(BuildContext context, Color houseColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: houseColor.withValues(alpha: 0.1),
        ),
        labelColor: houseColor,
        unselectedLabelColor: ThemeColors.textSecondary(context),
        labelStyle: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(
            text: 'Stats',
            icon: Icon(Icons.analytics_outlined, size: 20),
          ),
          Tab(
            text: 'Announcements',
            icon: Icon(Icons.announcement_outlined, size: 20),
          ),
          Tab(
            text: 'Events',
            icon: Icon(Icons.event_outlined, size: 20),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsTab(BuildContext context, Color houseColor, Map<String, int> categoryPoints, List<Activity> activities) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // House Stats Card
          _buildHouseStatsCard(context, houseColor),
          
          const SizedBox(height: 20),
          
          // Points Breakdown
          _buildPointsBreakdown(context, houseColor, categoryPoints),
          
          const SizedBox(height: 20),
          
          // Recent Activities
          _buildRecentActivities(context, activities),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }
  
  Widget _buildAnnouncementsTab(BuildContext context, Color houseColor) {
    // Sample announcements data
    final announcements = [
      {
        'id': '1',
        'title': 'House Meeting Tomorrow',
        'content': 'All Topaz Tigers are invited to our monthly house meeting tomorrow at 4 PM in the main hall. We\'ll be discussing upcoming events and initiatives.',
        'author': 'Sarah Johnson',
        'authorRole': 'House Captain',
        'timestamp': '2 hours ago',
        'likes': 12,
        'comments': 5,
      },
      {
        'id': '2',
        'title': 'Inter-House Football Match',
        'content': 'Great job everyone on our victory against the Ruby Rhinos yesterday! Special thanks to our football team for their outstanding performance.',
        'author': 'Mike Chen',
        'authorRole': 'Sports Coordinator',
        'timestamp': '1 day ago',
        'likes': 24,
        'comments': 8,
      },
      {
        'id': '3',
        'title': 'Study Group Formation',
        'content': 'Looking to form study groups for the upcoming exams. If you\'re interested in joining or leading a group, please comment below with your subjects.',
        'author': 'Emma Davis',
        'authorRole': 'Academic Secretary',
        'timestamp': '3 days ago',
        'likes': 18,
        'comments': 15,
      },
    ];
    
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Create New Announcement Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: () => _showCreateAnnouncementDialog(context, houseColor),
              icon: const Icon(Icons.add, size: 20),
              label: Text(
                'Create Announcement',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: houseColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Announcements List
          ...announcements.map((announcement) => _buildAnnouncementCard(
            context,
            houseColor,
            announcement,
          )),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }
  
  Widget _buildEventsTab(BuildContext context, Color houseColor) {
    // Sample events data
    final events = [
      {
        'id': '1',
        'title': 'Inter-House Dance Competition',
        'description': 'Solo dance competition between all houses. Show your moves and represent Topaz Tigers!',
        'date': '2024-01-15',
        'time': '6:00 PM - 9:00 PM',
        'venue': 'Main Auditorium',
        'enrollments': 8,
        'maxEnrollments': 15,
        'deadline': '2024-01-10',
        'status': 'Open',
      },
      {
        'id': '2',
        'title': 'Science Quiz Championship',
        'description': 'Test your scientific knowledge in this inter-house quiz competition.',
        'date': '2024-01-20',
        'time': '4:00 PM - 6:00 PM',
        'venue': 'Science Lab',
        'enrollments': 12,
        'maxEnrollments': 20,
        'deadline': '2024-01-15',
        'status': 'Open',
      },
      {
        'id': '3',
        'title': 'Art & Craft Exhibition',
        'description': 'Submit your creative artworks for the inter-house exhibition.',
        'date': '2024-01-25',
        'time': '10:00 AM - 4:00 PM',
        'venue': 'Art Gallery',
        'enrollments': 5,
        'maxEnrollments': 25,
        'deadline': '2024-01-22',
        'status': 'Closed',
      },
    ];
    
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Admin Note (if user is admin)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: houseColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: houseColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  color: houseColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'As a house admin, you can see all enrollments and manage events.',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: houseColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Events List
          ...events.map((event) => _buildEventCard(
            context,
            houseColor,
            event,
          )),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }
  
  Widget _buildHouseStatsCard(BuildContext context, Color houseColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Points circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: houseColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: houseColor,
                width: 3,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.house.points}',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: houseColor,
                    ),
                  ),
                  Text(
                    'pts',
                    style: GoogleFonts.urbanist(
                      fontSize: 10,
                      color: houseColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 20),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Standing',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: ThemeColors.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      widget.house.status == 'Rising' 
                          ? Icons.trending_up
                          : widget.house.status == 'Falling'
                              ? Icons.trending_down
                              : Icons.trending_flat,
                      color: widget.house.status == 'Rising' 
                          ? Colors.green
                          : widget.house.status == 'Falling'
                              ? Colors.red
                              : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.house.status,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.text(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryWithOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Rank #1 Overall',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBreakdown(
    BuildContext context,
    Color houseColor,
    Map<String, int> categoryPoints,
  ) {
    final totalPoints = categoryPoints.values.fold(0, (a, b) => a + b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: ThemeColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Points Breakdown',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.text(context),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          ...categoryPoints.entries.map((entry) {
            final category = entry.key;
            final points = entry.value;
            final percentage = points / totalPoints;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: houseColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            _getCategoryIcon(category),
                            color: houseColor,
                            size: 20,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: Text(
                          category,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.text(context),
                          ),
                        ),
                      ),
                      
                      Text(
                        '$points pts',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: houseColor,
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      Text(
                        '${(percentage * 100).round()}%',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: ThemeColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Progress bar
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ThemeColors.cardBorder(context),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: percentage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: houseColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context, List<Activity> activities) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: ThemeColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Recent Activities',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.text(context),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (activities.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No recent activities',
                  style: GoogleFonts.urbanist(
                    color: ThemeColors.textSecondary(context),
                  ),
                ),
              ),
            )
          else
            ...activities.take(5).map((activity) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(activity.houseColorHex.substring(1), radix: 16) + 0xFF000000,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.text(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activity.category.toUpperCase(),
                          style: GoogleFonts.urbanist(
                            fontSize: 11,
                            color: ThemeColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Text(
                    '+${activity.points}',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, Color houseColor, Map<String, dynamic> announcement) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with author info
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: houseColor.withValues(alpha: 0.2),
                child: Text(
                  announcement['author']!.split(' ').map((name) => name[0]).join(),
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: houseColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement['author']!,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.text(context),
                      ),
                    ),
                    Text(
                      announcement['authorRole']!,
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: ThemeColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                announcement['timestamp']!,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: ThemeColors.textSecondary(context),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Title
          Text(
            announcement['title']!,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColors.text(context),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Content
          Text(
            announcement['content']!,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: ThemeColors.text(context),
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Actions (like, comment)
          Row(
            children: [
              _buildActionButton(
                context,
                houseColor,
                Icons.favorite_border,
                '${announcement['likes']} likes',
                () => _likeAnnouncement(announcement['id']!),
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                context,
                houseColor,
                Icons.comment_outlined,
                '${announcement['comments']} comments',
                () => _showCommentsDialog(context, houseColor, announcement),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildEventCard(BuildContext context, Color houseColor, Map<String, dynamic> event) {
    final isOpen = event['status'] == 'Open';
    final enrollmentPercentage = (event['enrollments'] as int) / (event['maxEnrollments'] as int);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status badge
          Row(
            children: [
              Expanded(
                child: Text(
                  event['title']!,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOpen 
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  event['status']!,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOpen ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Description
          Text(
            event['description']!,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: ThemeColors.textSecondary(context),
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Event details
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: ThemeColors.textSecondary(context),
              ),
              const SizedBox(width: 4),
              Text(
                event['date']!,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: ThemeColors.textSecondary(context),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                size: 16,
                color: ThemeColors.textSecondary(context),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event['time']!,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: ThemeColors.textSecondary(context),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: ThemeColors.textSecondary(context),
              ),
              const SizedBox(width: 4),
              Text(
                event['venue']!,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: ThemeColors.textSecondary(context),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Enrollment status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: houseColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: houseColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Enrollments: ${event['enrollments']}/${event['maxEnrollments']}',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.text(context),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Deadline: ${event['deadline']}',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: ThemeColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Enrollment progress bar
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ThemeColors.cardBorder(context),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: enrollmentPercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: houseColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isOpen 
                      ? () => _enrollInEvent(context, houseColor, event)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOpen ? houseColor : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isOpen ? 'Enroll Now' : 'Closed',
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _viewEnrollments(context, houseColor, event),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.surface(context),
                  foregroundColor: houseColor,
                  side: BorderSide(color: houseColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'View Enrollments',
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(BuildContext context, Color houseColor, IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: ThemeColors.textSecondary(context),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: ThemeColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showCreateAnnouncementDialog(BuildContext context, Color houseColor) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: ThemeColors.cardBackground(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.announcement_outlined,
              color: houseColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Create Announcement',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.text(context),
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                style: TextStyle(color: ThemeColors.text(context)),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: houseColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contentController,
                style: TextStyle(color: ThemeColors.text(context)),
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: houseColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: ThemeColors.textSecondary(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Announcement "${titleController.text}" created successfully!',
                      style: GoogleFonts.urbanist(),
                    ),
                    backgroundColor: houseColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: houseColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Create',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _likeAnnouncement(String announcementId) {
    // Implementation for liking an announcement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Liked announcement!',
          style: GoogleFonts.urbanist(),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  
  void _showCommentsDialog(BuildContext context, Color houseColor, Map<String, dynamic> announcement) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: ThemeColors.cardBackground(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Comments',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comments feature coming soon!',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: houseColor),
            ),
          ),
        ],
      ),
    );
  }
  
  void _enrollInEvent(BuildContext context, Color houseColor, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: ThemeColors.cardBackground(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Confirm Enrollment',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        content: Text(
          'Are you sure you want to enroll in "${event['title']}"?',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: ThemeColors.textSecondary(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Successfully enrolled in "${event['title']}"!',
                    style: GoogleFonts.urbanist(),
                  ),
                  backgroundColor: houseColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: houseColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Enroll',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _viewEnrollments(BuildContext context, Color houseColor, Map<String, dynamic> event) {
    // Sample enrollment data
    final enrollments = [
      {'name': 'Alice Johnson', 'enrolledAt': '2024-01-05 10:30 AM'},
      {'name': 'Bob Smith', 'enrolledAt': '2024-01-05 2:15 PM'},
      {'name': 'Carol Davis', 'enrolledAt': '2024-01-06 9:45 AM'},
      {'name': 'David Brown', 'enrolledAt': '2024-01-06 4:20 PM'},
      {'name': 'Emily Wilson', 'enrolledAt': '2024-01-07 11:10 AM'},
    ];
    
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: ThemeColors.cardBackground(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.people_outline,
              color: houseColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Enrollments - ${event['title']}',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.text(context),
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: enrollments.isEmpty
              ? Center(
                  child: Text(
                    'No enrollments yet',
                    style: GoogleFonts.urbanist(
                      color: ThemeColors.textSecondary(context),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: enrollments.length,
                  itemBuilder: (context, index) {
                    final enrollment = enrollments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: houseColor.withValues(alpha: 0.2),
                        child: Text(
                          enrollment['name']!.split(' ').map((name) => name[0]).join(),
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: houseColor,
                          ),
                        ),
                      ),
                      title: Text(
                        enrollment['name']!,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.text(context),
                        ),
                      ),
                      subtitle: Text(
                        'Enrolled: ${enrollment['enrolledAt']}',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: ThemeColors.textSecondary(context),
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: houseColor),
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Icons.sports_basketball;
      case 'academic':
        return Icons.school;
      case 'cultural':
        return Icons.theater_comedy;
      case 'community':
        return Icons.people;
      case 'science':
        return Icons.science;
      default:
        return Icons.category;
    }
  }
}
