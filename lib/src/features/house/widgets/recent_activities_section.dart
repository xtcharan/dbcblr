import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/activity.dart';
import '../../../shared/utils/theme_colors.dart';

class RecentActivitiesSection extends StatelessWidget {
  final List<Activity> activities;

  const RecentActivitiesSection({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.primaryWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: ThemeColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Point Activities',
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.text(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Latest point earning activities across all houses',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: ThemeColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ThemeColors.cardBorder(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${activities.length} Activities',
                  style: GoogleFonts.urbanist(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.textSecondary(context),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Activities List
          if (activities.isEmpty)
            _buildEmptyState(context)
          else
            ...activities.map((activity) => _buildActivityItem(context, activity)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: ThemeColors.iconSecondary(context),
            ),
            const SizedBox(height: 12),
            Text(
              'No Recent Activities',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeColors.text(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Point earning activities will appear here',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: ThemeColors.textSecondary(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, Activity activity) {
    final houseColor = Color(
      int.parse(activity.houseColorHex.substring(1), radix: 16) + 0xFF000000,
    );
    
    final timeAgo = _getTimeAgo(activity.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.inputBackground(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.inputBorder(context),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Activity icon and house indicator
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: houseColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(activity.category),
                    color: houseColor,
                    size: 22,
                  ),
                ),
              ),
              // House color indicator
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: houseColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ThemeColors.cardBackground(context),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 12),
          
          // Activity details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity title
                Text(
                  activity.title,
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.text(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                // House and category
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: houseColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        activity.house,
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: houseColor,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    Text(
                      '•',
                      style: GoogleFonts.urbanist(
                        color: ThemeColors.textSecondary(context),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    Text(
                      activity.category.toUpperCase(),
                      style: GoogleFonts.urbanist(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: ThemeColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Time ago
                Text(
                  timeAgo,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: ThemeColors.textTertiary(context),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Points earned
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withValues(alpha: 0.1),
                      Colors.green.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      size: 12,
                      color: Colors.green,
                    ),
                    Text(
                      '${activity.points}',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                'points',
                style: GoogleFonts.urbanist(
                  fontSize: 10,
                  color: ThemeColors.textTertiary(context),
                ),
              ),
            ],
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
        return Icons.star;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}