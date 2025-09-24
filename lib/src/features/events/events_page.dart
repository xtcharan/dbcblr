import 'package:flutter/material.dart';
import 'event_search_bar.dart';
import 'filter_modal.dart';
import '../../shared/models/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = "";
  FilterState _filterState = FilterState.empty();
  late TabController _tabController;

  // Calendar state
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;

  final List<String> _weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // Sample events data
  final List<Event> _events = [
    Event(
      id: "1",
      title: "Academic Conference 2025",
      description:
          "Annual academic conference featuring keynote speakers from top universities. Topics include AI research, quantum computing, and sustainable engineering.",
      startDate: DateTime(2025, 9, 25, 9, 0),
      endDate: DateTime(2025, 9, 25, 17, 0),
      location: "Main Auditorium",
      category: "Academic",
      isHouseEvent: false,
      eventImage:
          "https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070&auto=format&fit=crop",
    ),
    Event(
      id: "2",
      title: "Cultural Fest: Harmony 2025",
      description:
          "Three-day cultural extravaganza featuring music, dance, drama performances from students across departments. Special guest performances each evening.",
      startDate: DateTime(2025, 10, 5, 10, 0),
      endDate: DateTime(2025, 10, 7, 20, 0),
      location: "Main Auditorium",
      category: "Cultural",
      isHouseEvent: false,
      eventImage:
          "https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?q=80&w=2070&auto=format&fit=crop",
    ),
    Event(
      id: "3",
      title: "Inter-House Basketball Tournament",
      description:
          "Annual basketball tournament between all houses. Final match will be presided by the college Dean and Sports Director.",
      startDate: DateTime(2025, 9, 28, 9, 0),
      endDate: DateTime(2025, 9, 28, 18, 0),
      location: "Sports Complex",
      category: "Sports",
      isHouseEvent: true,
      eventImage:
          "https://images.unsplash.com/photo-1518063319789-7217e6706b04?q=80&w=2069&auto=format&fit=crop",
    ),
    Event(
      id: "4",
      title: "Hackathon 2025: Code for Change",
      description:
          "24-hour coding competition focused on developing solutions for environmental sustainability. Prizes worth ?1,00,000 to be won.",
      startDate: DateTime(2025, 10, 15, 9, 0),
      endDate: DateTime(2025, 10, 16, 9, 0),
      location: "Library",
      category: "Academic",
      isHouseEvent: false,
      eventImage:
          "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?q=80&w=2070&auto=format&fit=crop",
    ),
    Event(
      id: "5",
      title: "Freshers Party: New Beginnings",
      description:
          "Welcome party for first-year students. Includes talent show, games, DJ, and dinner. Dress code: Semi-formal.",
      startDate: DateTime(2025, 9, 24, 18, 0),
      endDate: DateTime(2025, 9, 24, 22, 0),
      location: "Cafeteria",
      category: "Social",
      isHouseEvent: true,
      eventImage:
          "https://images.unsplash.com/photo-1516450360452-9312f5463805?q=80&w=2070&auto=format&fit=crop",
    ),
    Event(
      id: "6",
      title: "Photography Workshop",
      description:
          "Hands-on workshop on photography basics, composition techniques, and post-processing. Bring your own camera if possible, limited equipment available for loan.",
      startDate: DateTime(2025, 10, 10, 14, 0),
      endDate: DateTime(2025, 10, 10, 17, 0),
      location: "Outdoor Ground",
      category: "Cultural",
      isHouseEvent: false,
      eventImage:
          "https://images.unsplash.com/photo-1542038784456-1ea8e935640e?q=80&w=2070&auto=format&fit=crop",
    ),
    Event(
      id: "7",
      title: "Career Fair 2025",
      description:
          "Annual recruitment drive with 50+ companies offering internships and full-time positions. Bring multiple copies of your resume and dress professionally.",
      startDate: DateTime(2025, 10, 20, 10, 0),
      endDate: DateTime(2025, 10, 20, 16, 0),
      location: "Main Auditorium",
      category: "Academic",
      isHouseEvent: false,
      eventImage:
          "https://images.unsplash.com/photo-1560523159-4a9692d222f9?q=80&w=2036&auto=format&fit=crop",
    ),
    Event(
      id: "8",
      title: "House Chess Tournament",
      description:
          "Annual chess tournament between houses. Both classical and blitz formats will be played. Registration required by October 1st.",
      startDate: DateTime(2025, 10, 3, 13, 0),
      endDate: DateTime(2025, 10, 3, 18, 0),
      location: "Library",
      category: "Sports",
      isHouseEvent: true,
      eventImage:
          "https://images.unsplash.com/photo-1529699211952-734e80c4d42b?q=80&w=2071&auto=format&fit=crop",
    ),
    Event(
      id: "9",
      title: "Diwali Celebration",
      description:
          "Campus-wide Diwali celebration featuring rangoli competition, lamp lighting ceremony, cultural performances, and dinner.",
      startDate: DateTime(2025, 10, 31, 17, 0),
      endDate: DateTime(2025, 10, 31, 22, 0),
      location: "Outdoor Ground",
      category: "Cultural",
      isHouseEvent: false,
      eventImage:
          "https://images.unsplash.com/photo-1606327054536-e37e655d4f4a?q=80&w=2071&auto=format&fit=crop",
    ),
    Event(
      id: "10",
      title: "Book Club Meeting: Sci-Fi Special",
      description:
          "Monthly book club meeting discussing selected science fiction novels. This month's picks: Project Hail Mary by Andy Weir and The Ministry for the Future by Kim Stanley Robinson.",
      startDate: DateTime(2025, 9, 26, 16, 0),
      endDate: DateTime(2025, 9, 26, 18, 0),
      location: "Library",
      category: "Social",
      isHouseEvent: false,
      eventImage:
          "https://images.unsplash.com/photo-1491309055486-24ae511c15c7?q=80&w=2070&auto=format&fit=crop",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  List<Event> get _filteredEvents {
    // Start with search query filter
    List<Event> filtered = _events.where((event) {
      return event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Apply category filter
    if (_filterState.categories.isNotEmpty) {
      filtered = filtered
          .where((event) => _filterState.categories.contains(event.category))
          .toList();
    }

    // Apply date range filter
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeekEnd = today.add(const Duration(days: 7));
    final thisMonthEnd = DateTime(now.year, now.month + 1, 0);

    if (_filterState.dateRange == 'Today') {
      filtered = filtered.where((event) {
        final eventDate = DateTime(
          event.startDate.year,
          event.startDate.month,
          event.startDate.day,
        );
        return eventDate.isAtSameMomentAs(today);
      }).toList();
    } else if (_filterState.dateRange == 'This Week') {
      filtered = filtered.where((event) {
        return event.startDate.isAfter(
              today.subtract(const Duration(days: 1)),
            ) &&
            event.startDate.isBefore(thisWeekEnd);
      }).toList();
    } else if (_filterState.dateRange == 'This Month') {
      filtered = filtered.where((event) {
        return event.startDate.isAfter(
              today.subtract(const Duration(days: 1)),
            ) &&
            event.startDate.isBefore(thisMonthEnd);
      }).toList();
    }
    // Custom range would be handled in a real app with date picker

    // Apply house filter
    if (_filterState.houseOnly) {
      filtered = filtered.where((event) => event.isHouseEvent).toList();
    }

    // Apply location filter
    if (_filterState.locations.isNotEmpty) {
      filtered = filtered
          .where((event) => _filterState.locations.contains(event.location))
          .toList();
    }

    return filtered;
  }

  List<Event> get _upcomingEvents {
    final now = DateTime.now();
    return _filteredEvents
        .where((event) => event.startDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  List<Event> get _pastEvents {
    final now = DateTime.now();
    return _filteredEvents
        .where((event) => event.startDate.isBefore(now))
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate)); // Most recent first
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text("Events"),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          EventSearchBar(
            controller: _searchController,
            onSearch: (query) => setState(() => _searchQuery = query),
            filterState: _filterState,
            onFilterApplied: (newState) =>
                setState(() => _filterState = newState),
          ),

          // Compact Calendar Section
          _buildCompactCalendar(),

          // Tab Bar (Upcoming | Past)
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor:
                  Theme.of(context).brightness == Brightness.light
                  ? Colors.black54
                  : Colors.grey[400],
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Past Events'),
              ],
            ),
          ),

          // Events List with TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEventsTab(_upcomingEvents, 'No upcoming events'),
                _buildEventsTab(_pastEvents, 'No past events'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCalendar() {
    return Column(
      children: [
        // Month header with navigation (no background)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month - 1,
                    );
                  });
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showFullCalendar(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _months[_selectedMonth.month - 1],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.calendar_month,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month + 1,
                    );
                  });
                },
              ),
            ],
          ),
        ),

        // Scrollable date squares
        SizedBox(
          height: 80,
          child: PageView.builder(
            controller: PageController(),
            itemBuilder: (context, pageIndex) {
              // Each page shows 5 consecutive dates
              final startDate = DateTime(
                _selectedMonth.year,
                _selectedMonth.month,
                1 + (pageIndex * 5),
              );
              final dates = List.generate(5, (index) {
                final date = DateTime(
                  startDate.year,
                  startDate.month,
                  startDate.day + index,
                );
                // Only show dates that exist in the month
                final lastDayOfMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month + 1,
                  0,
                ).day;
                if (date.day <= lastDayOfMonth &&
                    date.month == _selectedMonth.month) {
                  return date;
                }
                return null;
              }).where((date) => date != null).cast<DateTime>().toList();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: dates
                      .map((date) => _buildDateSquare(date))
                      .toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSquare(DateTime date) {
    final isSelected =
        _selectedDate != null &&
        _selectedDate!.day == date.day &&
        _selectedDate!.month == date.month &&
        _selectedDate!.year == date.year;
    final isToday =
        date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = isSelected ? null : date;
        });
      },
      child: Container(
        width: 55,
        height: 70,
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
        ), // Add spacing between squares
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : isToday
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF242424),
          borderRadius: BorderRadius.circular(12),
          border: isToday && !isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.2),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : isToday
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _weekDays[date.weekday % 7],
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).brightness == Brightness.light
                    ? Colors.black54
                    : Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullCalendar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FullCalendarModal(
        selectedMonth: _selectedMonth,
        selectedDate: _selectedDate,
        onDateSelected: (date) {
          setState(() {
            _selectedDate = date;
            _selectedMonth = DateTime(date.year, date.month);
          });
          Navigator.pop(context);
        },
        onMonthChanged: (month) {
          // Update month in modal - handled within the modal
        },
      ),
    );
  }

  Widget _buildEventsTab(List<Event> events, String emptyMessage) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 70,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[400]
                  : Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[700]
                    : Colors.grey[300],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  setState(() => _filterState = FilterState.empty()),
              child: const Text("Clear filters"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(Event event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      clipBehavior: Clip.antiAlias, // Important for image overflow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        onTap: () {
          // Event details page navigation would go here
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            if (event.eventImage != null)
              SizedBox(
                width: double.infinity,
                height: 180,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image
                    Image.network(
                      event.eventImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                        );
                      },
                    ),
                    // Gradient overlay for better text visibility
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(
                                alpha: 179,
                              ), // 0.7 * 255 ≈ 179
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Category and house event labels on the image
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 204,
                          ), // 0.8 * 255 ≈ 204
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          event.category,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    if (event.isHouseEvent)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 204,
                            ), // 0.8 * 255 ≈ 204
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'House Event',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Only show category and house event labels if no image
                  if (event.eventImage == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            event.category,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (event.isHouseEvent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              'House Event',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  if (event.eventImage == null) const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[700]
                          : Colors.grey[300],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[700]
                            : Colors.grey[300],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.location,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[700]
                              : Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[700]
                            : Colors.grey[300],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(event.startDate),
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[700]
                              : Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  // Add a date range indicator if event spans multiple days
                  if (!_isSameDay(event.startDate, event.endDate))
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 4),
                      child: Text(
                        "to ${_formatDate(event.endDate)}",
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[700]
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    String period = date.hour >= 12 ? 'PM' : 'AM';
    int displayHour = date.hour > 12 ? date.hour - 12 : date.hour;
    if (displayHour == 0) displayHour = 12; // Handle midnight

    return "${date.day} ${months[date.month - 1]}, ${date.year} at $displayHour:${date.minute.toString().padLeft(2, '0')} $period";
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

class _FullCalendarModal extends StatefulWidget {
  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;

  const _FullCalendarModal({
    required this.selectedMonth,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  State<_FullCalendarModal> createState() => _FullCalendarModalState();
}

class _FullCalendarModalState extends State<_FullCalendarModal> {
  late DateTime _currentMonth;
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<String> _weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.selectedMonth;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // Header with month navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).colorScheme.primary,
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.primary,
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _weekDays
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black54
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Calendar grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCalendarGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final firstDayWeekday =
        firstDayOfMonth.weekday % 7; // Convert to 0-6 where Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    // Calculate previous month days to show
    final prevMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    final lastDayOfPrevMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      0,
    ).day;

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
    final isSelected =
        widget.selectedDate != null &&
        widget.selectedDate!.day == date.day &&
        widget.selectedDate!.month == date.month &&
        widget.selectedDate!.year == date.year;
    final isToday =
        date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;

    return GestureDetector(
      onTap: () => widget.onDateSelected(date),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : isToday
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                )
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.white
                  : !isCurrentMonth
                  ? (Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[400]
                        : Colors.grey[600])
                  : isToday
                  ? Theme.of(context).colorScheme.primary
                  : (Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
