import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/schedule.dart';
import '../../../services/api_service.dart';
import '../../../shared/utils/theme_colors.dart';
import 'day_schedule_view.dart';
import 'create_schedule_dialog.dart';

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
  late DateTime _selectedDate;
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final List<String> _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  
  // Schedule data
  final ApiService _apiService = ApiService();
  List<Schedule> _schedules = [];
  bool _isLoadingSchedules = false;
  bool _isLoggedIn = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
    _selectedDate = widget.selectedDate;
    _checkAuthAndLoadSchedules();
  }

  Future<void> _checkAuthAndLoadSchedules() async {
    final loggedIn = await _apiService.isLoggedIn();
    setState(() => _isLoggedIn = loggedIn);
    
    if (loggedIn) {
      try {
        final profile = await _apiService.getProfile();
        setState(() => _isAdmin = profile['role'] == 'admin');
      } catch (_) {}
    }
    
    await _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() => _isLoadingSchedules = true);
    
    try {
      final schedulesData = await _apiService.getSchedules(_selectedDate);
      setState(() {
        _schedules = schedulesData.map((json) => Schedule.fromJson(json)).toList();
        _isLoadingSchedules = false;
      });
    } catch (e) {
      setState(() {
        _schedules = [];
        _isLoadingSchedules = false;
      });
    }
  }

  void _onDateTap(DateTime date) {
    setState(() => _selectedDate = date);
    widget.onDateSelected(date);
    _loadSchedules();
  }

  Future<void> _showAddScheduleDialog() async {
    if (!_isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to add schedules')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => CreateScheduleDialog(
        initialDate: _selectedDate,
        isAdmin: _isAdmin,
        onSave: (title, description, date, startTime, endTime, location, scheduleType) async {
          try {
            await _apiService.createSchedule(
              title: title,
              description: description,
              scheduleDate: date,
              startTime: startTime,
              endTime: endTime,
              location: location,
              scheduleType: scheduleType,
            );
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Schedule added successfully!')),
              );
              _loadSchedules();
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _editSchedule(Schedule schedule) async {
    await showDialog(
      context: context,
      builder: (context) => CreateScheduleDialog(
        initialDate: schedule.scheduleDate,
        scheduleToEdit: schedule,
        isAdmin: _isAdmin,
        onSave: (title, description, date, startTime, endTime, location, scheduleType) async {
          try {
            await _apiService.updateSchedule(
              id: schedule.id,
              title: title,
              description: description,
              scheduleDate: date,
              startTime: startTime,
              endTime: endTime,
              location: location,
            );
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Schedule updated successfully!')),
              );
              _loadSchedules();
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _deleteSchedule(Schedule schedule) async {
    try {
      await _apiService.deleteSchedule(schedule.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule deleted')),
        );
        _loadSchedules();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: ThemeColors.background(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: ThemeColors.textSecondary(context).withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // Header with month navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: ThemeColors.primary,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.text(context),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: ThemeColors.primary,
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
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: ThemeColors.textSecondary(context),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Calendar grid (compact)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCalendarGrid(),
          ),

          const SizedBox(height: 16),
          
          // Divider
          Divider(
            color: ThemeColors.cardBorder(context),
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),

          // Day schedule view (scrollable)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: DayScheduleView(
                selectedDate: _selectedDate,
                schedules: _schedules,
                isLoading: _isLoadingSchedules,
                onAddSchedule: _isLoggedIn ? _showAddScheduleDialog : null,
                onScheduleEdit: _editSchedule,
                onScheduleDelete: _deleteSchedule,
                canEditOfficial: _isAdmin,
              ),
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
                  backgroundColor: ThemeColors.primary,
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
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    final prevMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    final lastDayOfPrevMonth = DateTime(_currentMonth.year, _currentMonth.month, 0).day;

    List<Widget> dayWidgets = [];

    // Previous month days
    for (int i = firstDayWeekday - 1; i >= 0; i--) {
      final day = lastDayOfPrevMonth - i;
      dayWidgets.add(
        _buildDayWidget(
          DateTime(prevMonth.year, prevMonth.month, day),
          isCurrentMonth: false,
        ),
      );
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(
        _buildDayWidget(
          DateTime(_currentMonth.year, _currentMonth.month, day),
          isCurrentMonth: true,
        ),
      );
    }

    // Next month days
    final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    int remainingDays = 42 - dayWidgets.length;
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
      childAspectRatio: 1.2,
      children: dayWidgets,
    );
  }

  Widget _buildDayWidget(DateTime date, {required bool isCurrentMonth}) {
    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: () => _onDateTap(date),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeColors.primary
              : isToday
                  ? ThemeColors.primary.withOpacity(0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: ThemeColors.primary, width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.black
                  : !isCurrentMonth
                      ? ThemeColors.textSecondary(context).withOpacity(0.4)
                      : isToday
                          ? ThemeColors.primary
                          : ThemeColors.text(context),
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

