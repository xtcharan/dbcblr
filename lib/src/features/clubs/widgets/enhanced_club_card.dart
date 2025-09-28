import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/club.dart';
import '../../../shared/utils/theme_colors.dart';

class EnhancedClubCard extends StatelessWidget {
  final Club club;
  final VoidCallback onTap;

  const EnhancedClubCard({
    super.key,
    required this.club,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nextEvent = club.nextEvent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground(context),
        borderRadius: BorderRadius.circular(20),
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
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Club Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: club.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        club.icon,
                        color: club.primaryColor,
                        size: 28,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Club Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            club.shortName,
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.text(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            club.tagline,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: ThemeColors.textSecondary(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: club.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: club.primaryColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            club.rating.toString(),
                            style: GoogleFonts.urbanist(
                              color: club.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Stats Row
                Row(
                  children: [
                    _QuickStat(
                      icon: Icons.people,
                      value: club.memberCount.toString(),
                      label: 'Members',
                    ),
                    const SizedBox(width: 20),
                    _QuickStat(
                      icon: Icons.event,
                      value: club.upcomingEventsCount.toString(),
                      label: 'Events',
                    ),
                    const SizedBox(width: 20),
                    _QuickStat(
                      icon: Icons.emoji_events,
                      value: club.achievements.length.toString(),
                      label: 'Awards',
                    ),
                  ],
                ),
                
                // Next Event Preview
                if (nextEvent != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: club.primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: club.primaryColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: club.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getEventIcon(nextEvent.type),
                            color: club.primaryColor,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nextEvent.title,
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: ThemeColors.text(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatEventDate(nextEvent.date),
                                style: GoogleFonts.urbanist(
                                  fontSize: 11,
                                  color: ThemeColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (nextEvent.isRegistrationOpen)
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
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: club.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      'See Events',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getEventIcon(EventType type) {
    switch (type) {
      case EventType.hackathon:
        return Icons.code;
      case EventType.workshop:
        return Icons.build;
      case EventType.competition:
        return Icons.emoji_events;
      case EventType.seminar:
        return Icons.mic;
      case EventType.cultural:
        return Icons.palette;
      case EventType.social:
        return Icons.groups;
      case EventType.networking:
        return Icons.connect_without_contact;
      default:
        return Icons.event;
    }
  }

  String _formatEventDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    
    if (diff == 0) return 'Today • ${_formatTime(date)}';
    if (diff == 1) return 'Tomorrow • ${_formatTime(date)}';
    if (diff < 7) return '$diff days • ${_formatTime(date)}';
    
    return '${date.day}/${date.month} • ${_formatTime(date)}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _QuickStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: ThemeColors.iconSecondary(context),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color: ThemeColors.textSecondary(context),
          ),
        ),
      ],
    );
  }
}