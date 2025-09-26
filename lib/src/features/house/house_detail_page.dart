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

class _HouseDetailPageState extends State<HouseDetailPage> {
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
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
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