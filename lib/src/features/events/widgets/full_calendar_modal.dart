import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FullCalendarModal extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const FullCalendarModal({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<FullCalendarModal> createState() => _FullCalendarModalState();
}

class _FullCalendarModalState extends State<FullCalendarModal> {
  late DateTime _currentMonth;
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final List<String> _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // Header with month navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFFFCB900),
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month - 1,
                      );
                    });
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${_months[_currentMonth.month - 1]} ${_currentMonth.year}',
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFFCB900),
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          // Week day headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: _weekDays
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Calendar grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCalendarGrid(),
            ),
          ),

          // Close button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCB900),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7; // Convert to 0-6 where Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    // Calculate previous month days to show
    final prevMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    final lastDayOfPrevMonth = DateTime(_currentMonth.year, _currentMonth.month, 0).day;

    List<Widget> dayWidgets = [];

    // Add previous month's trailing days
    for (int i = firstDayWeekday - 1; i >= 0; i--) {
      final day = lastDayOfPrevMonth - i;
      dayWidgets.add(
        _buildDayWidget(
          DateTime(prevMonth.year, prevMonth.month, day),
          isCurrentMonth: false,
        ),
      );
    }

    // Add current month days
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(
        _buildDayWidget(
          DateTime(_currentMonth.year, _currentMonth.month, day),
          isCurrentMonth: true,
        ),
      );
    }

    // Add next month's leading days to complete the grid
    final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    int remainingDays = 42 - dayWidgets.length; // 6 rows * 7 days = 42
    for (int day = 1; day <= remainingDays && dayWidgets.length < 42; day++) {
      dayWidgets.add(
        _buildDayWidget(
          DateTime(nextMonth.year, nextMonth.month, day),
          isCurrentMonth: false,
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildDayWidget(DateTime date, {required bool isCurrentMonth}) {
    final isSelected = _isSameDay(date, widget.selectedDate);
    final isToday = _isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: () {
        widget.onDateSelected(date);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFCB900)
              : isToday
                  ? const Color(0xFFFCB900).withValues(alpha: 0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(
                  color: const Color(0xFFFCB900),
                  width: 1,
                )
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.black
                  : !isCurrentMonth
                      ? Colors.white.withValues(alpha: 0.3)
                      : isToday
                          ? const Color(0xFFFCB900)
                          : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
