import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/utils/theme_colors.dart';

enum DateFilterType { upcomingEvents, today, tomorrow, thisWeek, thisMonth }

class DateFilterButtons extends StatelessWidget {
  final DateFilterType selectedFilter;
  final Function(DateFilterType) onFilterSelected;

  const DateFilterButtons({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
          _buildFilterButton(
            DateFilterType.upcomingEvents,
            'Upcoming',
            context,
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            DateFilterType.today,
            'Today',
            context,
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            DateFilterType.tomorrow,
            'Tomorrow',
            context,
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            DateFilterType.thisWeek,
            'This Week',
            context,
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            DateFilterType.thisMonth,
            'This Month',
            context,
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(DateFilterType filterType, String label, BuildContext context) {
    final isSelected = selectedFilter == filterType;
    
    return GestureDetector(
      onTap: () => onFilterSelected(filterType),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? ThemeColors.primary
              : ThemeColors.surface(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? ThemeColors.primary
                : ThemeColors.cardBorder(context),
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: ThemeColors.primaryWithOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.black : ThemeColors.text(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}