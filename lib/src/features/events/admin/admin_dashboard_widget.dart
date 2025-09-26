import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/event.dart';
import '../../../shared/utils/theme_colors.dart';

class AdminDashboardWidget extends StatelessWidget {
  final List<Event> events;
  final VoidCallback? onCreateEvent;
  final void Function(Event)? onEditEvent;
  final void Function(Event)? onDeleteEvent;

  const AdminDashboardWidget({
    super.key,
    required this.events,
    this.onCreateEvent,
    this.onEditEvent,
    this.onDeleteEvent,
  });

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = events
        .where((e) => e.startDate.isAfter(DateTime.now()))
        .take(5)
        .toList();
    
    final totalEvents = events.length;
    final todayEvents = events
        .where((e) => _isSameDay(e.startDate, DateTime.now()))
        .length;
    final thisWeekEvents = events
        .where((e) => e.startDate.isAfter(DateTime.now()) &&
                     e.startDate.isBefore(DateTime.now().add(const Duration(days: 7))))
        .length;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: ThemeColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeColors.cardBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ThemeColors.primaryWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.admin_panel_settings,
                  color: ThemeColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Dashboard',
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ThemeColors.text(context),
                      ),
                    ),
                    Text(
                      'Event management controls',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: ThemeColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Stats cards
          Row(
            children: [
              Expanded(child: _buildStatCard('Total', '$totalEvents', Icons.event, context)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Today', '$todayEvents', Icons.today, context)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('This Week', '$thisWeekEvents', Icons.date_range, context)),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Quick actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCreateEvent,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'Create Event',
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Show event management modal
                    _showEventManagement(context);
                  },
                  icon: const Icon(Icons.manage_search, size: 18),
                  label: Text(
                    'Manage',
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: ThemeColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ThemeColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          if (upcomingEvents.isNotEmpty) ...[
            const SizedBox(height: 20),
            
            // Recent events
            Row(
              children: [
                Text(
                  'Upcoming Events',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.text(context),
                  ),
                ),
                const Spacer(),
                Text(
                  '${upcomingEvents.length} events',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: ThemeColors.textSecondary(context),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            ...upcomingEvents.take(3).map((event) => _buildEventRow(event, context)),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.background(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.cardBorder(context)),
      ),
      child: Column(
        children: [
          Icon(icon, color: ThemeColors.primary, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ThemeColors.text(context),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 11,
              color: ThemeColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventRow(Event event, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColors.background(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ThemeColors.cardBorder(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: ThemeColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: ThemeColors.text(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_formatDate(event.startDate)} • ${event.location}',
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    color: ThemeColors.textSecondary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: ThemeColors.icon(context), size: 16),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (value) {
              if (value == 'edit' && onEditEvent != null) {
                onEditEvent!(event);
              } else if (value == 'delete' && onDeleteEvent != null) {
                onDeleteEvent!(event);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEventManagement(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: ThemeColors.surface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: ThemeColors.icon(context).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Event Management',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.text(context),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: ThemeColors.icon(context)),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Event list
            Expanded(
              child: events.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 48,
                            color: ThemeColors.iconSecondary(context),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No events found',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: ThemeColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return _buildEventManagementRow(event, context);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventManagementRow(Event event, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.background(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.cardBorder(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(event.category).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                event.startDate.day.toString(),
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w700,
                  color: _getCategoryColor(event.category),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.text(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: ThemeColors.iconSecondary(context)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: ThemeColors.textSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(event.category).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.category,
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getCategoryColor(event.category),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEditEvent != null)
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onEditEvent!(event);
                  },
                  icon: Icon(Icons.edit, color: ThemeColors.primary, size: 20),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
              if (onDeleteEvent != null)
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onDeleteEvent!(event);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return const Color(0xFF2196F3);
      case 'cultural':
        return const Color(0xFF9C27B0);
      case 'sports':
        return const Color(0xFF4CAF50);
      case 'social':
        return const Color(0xFFFF9800);
      case 'workshop':
        return const Color(0xFF607D8B);
      default:
        return ThemeColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}