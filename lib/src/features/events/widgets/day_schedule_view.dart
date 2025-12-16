import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/schedule.dart';
import '../../../shared/utils/theme_colors.dart';

/// Widget displaying the daily schedule with events listed by time
/// Shows both official (admin) and personal (student) schedules with visual differentiation
class DayScheduleView extends StatelessWidget {
  final DateTime selectedDate;
  final List<Schedule> schedules;
  final bool isLoading;
  final VoidCallback? onAddSchedule;
  final Function(Schedule)? onScheduleTap;
  final Function(Schedule)? onScheduleEdit;
  final Function(Schedule)? onScheduleDelete;
  final bool canEditOfficial; // True if user is admin

  const DayScheduleView({
    super.key,
    required this.selectedDate,
    required this.schedules,
    this.isLoading = false,
    this.onAddSchedule,
    this.onScheduleTap,
    this.onScheduleEdit,
    this.onScheduleDelete,
    this.canEditOfficial = false,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday = selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with date and add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isToday ? 'Today' : _formatDate(selectedDate),
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.text(context),
                ),
              ),
              if (onAddSchedule != null)
                GestureDetector(
                  onTap: onAddSchedule,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ThemeColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ThemeColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: ThemeColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),

          // Schedule list
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: ThemeColors.primary),
              ),
            )
          else if (schedules.isEmpty)
            _buildEmptyState(context)
          else
            ...schedules.map((schedule) => _buildScheduleItem(context, schedule)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 48,
            color: ThemeColors.textSecondary(context),
          ),
          const SizedBox(height: 16),
          Text(
            'No schedules for this day',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ThemeColors.textSecondary(context),
            ),
          ),
          if (onAddSchedule != null) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onAddSchedule,
              child: Text(
                'Tap + to add one',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: ThemeColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, Schedule schedule) {
    final isOfficial = schedule.isOfficial;
    final canEdit = isOfficial ? canEditOfficial : true;
    
    // Color scheme based on schedule type
    final backgroundColor = isOfficial
        ? ThemeColors.primary.withOpacity(0.08)
        : Colors.green.withOpacity(0.08);
    final borderColor = isOfficial
        ? ThemeColors.primary.withOpacity(0.25)
        : Colors.green.withOpacity(0.25);
    final timeColor = isOfficial ? ThemeColors.primary : Colors.green;

    return GestureDetector(
      onTap: () => onScheduleTap?.call(schedule),
      onLongPress: canEdit ? () => _showContextMenu(context, schedule) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time column
            SizedBox(
              width: 75,
              child: Text(
                schedule.formattedStartTime,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: timeColor,
                ),
              ),
            ),
            
            // Divider
            Container(
              width: 3,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: timeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Type indicator icon
                      Icon(
                        isOfficial ? Icons.school : Icons.person,
                        size: 14,
                        color: timeColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          schedule.title,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.text(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (schedule.location != null && schedule.location!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: ThemeColors.textSecondary(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          schedule.location!,
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: ThemeColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (schedule.endTime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Until ${schedule.formattedEndTime}',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: ThemeColors.textSecondary(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Edit indicator for editable items
            if (canEdit)
              Icon(
                Icons.more_vert,
                size: 16,
                color: ThemeColors.textSecondary(context),
              ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Schedule schedule) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: ThemeColors.surface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeColors.textSecondary(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              schedule.title,
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.text(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Edit option
            if (onScheduleEdit != null)
              ListTile(
                leading: Icon(Icons.edit, color: ThemeColors.primary),
                title: Text(
                  'Edit Schedule',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: ThemeColors.text(context),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onScheduleEdit?.call(schedule);
                },
              ),
            
            // Delete option
            if (onScheduleDelete != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Delete Schedule',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, schedule);
                },
              ),
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Schedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.surface(context),
        title: Text(
          'Delete Schedule',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${schedule.title}"?',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.urbanist(
                color: ThemeColors.textSecondary(context),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onScheduleDelete?.call(schedule);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.urbanist(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
