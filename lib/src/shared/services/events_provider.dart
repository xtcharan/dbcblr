import '../models/event.dart';

class EventsProvider {
  // Mock data for popular events
  static List<Event> getPopularEvents() {
    return [
      Event(
        id: 'event1',
        title: 'Billie Eilish Concert',
        description: 'Live performance by Billie Eilish on her world tour',
        startDate: DateTime(2025, 12, 15, 19, 30),
        endDate: DateTime(2025, 12, 15, 23, 0),
        location: 'Sigma Hall',
        category: 'Music Festival',
        isHouseEvent: false,
        eventImage:
            'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14',
      ),
      Event(
        id: 'event2',
        title: 'Brightlight Festival',
        description: 'Annual light and music festival',
        startDate: DateTime(2025, 10, 5, 18, 0),
        endDate: DateTime(2025, 10, 5, 23, 0),
        location: 'Central Auditorium',
        category: 'Festival Arts',
        isHouseEvent: true,
        eventImage:
            'https://images.unsplash.com/photo-1492684223066-81342ee5ff30',
      ),
      Event(
        id: 'event3',
        title: 'Tech Innovation Summit',
        description: 'Explore the latest in technology innovations',
        startDate: DateTime(2025, 11, 10, 9, 0),
        endDate: DateTime(2025, 11, 11, 17, 0),
        location: 'Conference Center',
        category: 'Technology',
        isHouseEvent: false,
        eventImage:
            'https://images.unsplash.com/photo-1540575467063-178a50c2df87',
      ),
    ];
  }

  // Get events by category
  static List<Event> getEventsByCategory(String category) {
    return getPopularEvents()
        .where((event) => event.category == category)
        .toList();
  }

  // Get all categories
  static List<String> getAllCategories() {
    return [
      'Music Festival',
      'Festival Arts',
      'Technology',
      'Sports',
      'Academic',
      'Workshop',
    ];
  }
}
