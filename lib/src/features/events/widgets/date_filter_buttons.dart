import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/utils/theme_colors.dart';

enum DateFilterType { today, tomorrow, thisWeek, thisMonth }

class DateFilterButtons extends StatelessWidget {
  final DateFilterType selectedFilter;
  final Function(DateFilterType) onFilterSelected;
  final Map<DateFilterType, int> eventCounts;

  const DateFilterButtons({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.eventCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterButton(
              DateFilterType.today,
              'Today',
              eventCounts[DateFilterType.today] ?? 0,
              context,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterButton(
              DateFilterType.tomorrow,
              'Tomorrow',
              eventCounts[DateFilterType.tomorrow] ?? 0,
              context,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterButton(
              DateFilterType.thisWeek,
              'This Week',
              eventCounts[DateFilterType.thisWeek] ?? 0,
              context,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterButton(
              DateFilterType.thisMonth,
              'This Month',
              eventCounts[DateFilterType.thisMonth] ?? 0,
              context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(DateFilterType filterType, String label, int count, BuildContext context) {
    final isSelected = selectedFilter == filterType;
    
    return GestureDetector(
      onTap: () => onFilterSelected(filterType),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? ThemeColors.primary
              : ThemeColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? ThemeColors.primary
                : ThemeColors.cardBorder(context),
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: ThemeColors.primaryWithOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : ThemeColors.text(context),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.black.withValues(alpha: 0.1)
                    : ThemeColors.surface(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count event${count != 1 ? 's' : ''}',
                style: GoogleFonts.urbanist(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isSelected 
                      ? Colors.black.withValues(alpha: 0.7)
                      : ThemeColors.textSecondary(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}