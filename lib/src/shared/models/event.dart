class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;
  final bool isHouseEvent;
  final String? eventImage; // Renamed from imageUrl to eventImage

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.isHouseEvent,
    this.eventImage, // Renamed from imageUrl to eventImage
  });

  // Helper method to check if the event falls within a specific date range
  bool isWithinRange(DateTime rangeStart, DateTime rangeEnd) {
    return (startDate.isAfter(rangeStart) ||
            startDate.isAtSameMomentAs(rangeStart)) &&
        (startDate.isBefore(rangeEnd) || startDate.isAtSameMomentAs(rangeEnd));
  }

  // Helper method to check if the event is happening on a specific date
  bool isOnDate(DateTime date) {
    return startDate.year == date.year &&
        startDate.month == date.month &&
        startDate.day == date.day;
  }
}
