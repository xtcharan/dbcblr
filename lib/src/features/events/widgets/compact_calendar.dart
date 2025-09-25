import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/utils/theme_colors.dart';

class CompactCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback? onMonthTap;

  const CompactCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.onMonthTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Generate dates for the next 14 days
    final dates = List.generate(14, (index) {
      return today.add(Duration(days: index));
    });

    return Column(
      children: [
        // Month Header
        GestureDetector(
          onTap: onMonthTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getMonthYear(selectedDate),
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.text(context),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: ThemeColors.primary,
                ),
              ],
            ),
          ),
        ),
        
        // Calendar Dates
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = _isSameDay(date, selectedDate);
              final isToday = _isSameDay(date, today);

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Day name
                      Text(
                        _getDayName(date.weekday),
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected 
                              ? ThemeColors.primary
                              : ThemeColors.text(context),
                        ),
                      ),
                      
                      const SizedBox(height: 6),
                      
                      // iPhone-style oval date container
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? ThemeColors.primary
                              : ThemeColors.surface(context), // Theme-aware background
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isToday && !isSelected
                                ? ThemeColors.primary
                                : isSelected
                                    ? ThemeColors.primary
                                    : ThemeColors.cardBorder(context), // Theme-aware border
                            width: isToday && !isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: ThemeColors.primaryWithOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ] : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected 
                                  ? Colors.black
                                  : isToday
                                      ? ThemeColors.primary
                                      : ThemeColors.text(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'MON';
      case 2: return 'TUE';
      case 3: return 'WED';
      case 4: return 'THU';
      case 5: return 'FRI';
      case 6: return 'SAT';
      case 7: return 'SUN';
      default: return '';
    }
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}