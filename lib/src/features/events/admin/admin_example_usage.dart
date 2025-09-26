import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/event.dart';
import '../../../shared/utils/theme_colors.dart';
import 'admin_dashboard_widget.dart';
import 'admin_demo_widget.dart';
import 'create_event_page.dart';

class AdminExampleUsage extends StatefulWidget {
  const AdminExampleUsage({super.key});

  @override
  State<AdminExampleUsage> createState() => _AdminExampleUsageState();
}

class _AdminExampleUsageState extends State<AdminExampleUsage> {
  final List<Event> _events = [
    Event(
      id: "1",
      title: "Academic Conference 2025",
      description: "Annual academic conference featuring keynote speakers.",
      startDate: DateTime(2025, 9, 25, 9, 0),
      endDate: DateTime(2025, 9, 25, 17, 0),
      location: "Main Auditorium",
      category: "Academic",
      isHouseEvent: false,
    ),
    Event(
      id: "2",
      title: "Cultural Fest: Harmony 2025",
      description: "Three-day cultural extravaganza.",
      startDate: DateTime(2025, 10, 5, 10, 0),
      endDate: DateTime(2025, 10, 7, 20, 0),
      location: "Main Campus",
      category: "Cultural",
      isHouseEvent: false,
    ),
  ];

  void _navigateToCreateEvent([Event? eventToEdit]) async {
    final result = await Navigator.of(context).push<Event>(
      MaterialPageRoute(
        builder: (context) => CreateEventPage(event: eventToEdit),
        fullscreenDialog: true,
      ),
    );
    
    if (result != null) {
      setState(() {
        if (eventToEdit != null) {
          // Update existing event
          final index = _events.indexWhere((e) => e.id == eventToEdit.id);
          if (index != -1) {
            _events[index] = result;
          }
        } else {
          // Add new event
          _events.add(result);
        }
      });
    }
  }

  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColors.surface(context),
          title: Text(
            'Delete Event',
            style: GoogleFonts.urbanist(
              color: ThemeColors.text(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${event.title}"?',
            style: GoogleFonts.urbanist(
              color: ThemeColors.text(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.textSecondary(context),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _events.removeWhere((e) => e.id == event.id);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Event deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.surface(context),
        elevation: 0,
        title: Text(
          'Admin Components Example',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Admin Demo Widget
            const AdminDemoWidget(),
            
            const SizedBox(height: 20),
            
            // Admin Dashboard Widget
            AdminDashboardWidget(
              events: _events,
              onCreateEvent: () => _navigateToCreateEvent(),
              onEditEvent: _navigateToCreateEvent,
              onDeleteEvent: _deleteEvent,
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// USAGE EXAMPLES:

/*

// 1. Basic Usage in Events Page:
if (isAdmin) AdminDashboardWidget(
  events: events,
  onCreateEvent: () => navigateToCreate(),
  onEditEvent: editEvent,
  onDeleteEvent: deleteEvent,
)

// 2. Demo Mode Indicator:
if (isDemoMode) const AdminDemoWidget()

// 3. Create/Edit Event:
Navigator.push(
  context, 
  MaterialPageRoute(
    builder: (context) => CreateEventPage(event: eventToEdit),
    fullscreenDialog: true,
  ),
)

// 4. Integration with existing Events Page:
// Add to your events_page.dart imports:
import 'admin/admin_dashboard_widget.dart';
import 'admin/create_event_page.dart';

// Then use in your build method:
if (_isAdmin) AdminDashboardWidget(
  events: _events,
  onCreateEvent: () => _navigateToCreateEvent(),
  onEditEvent: _navigateToCreateEvent,
  onDeleteEvent: _deleteEvent,
)

*/