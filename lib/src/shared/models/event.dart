class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;
  final bool isHouseEvent;
  final String? eventImage;
  final double? price;
  final int? availableSeats;
  final int? participantCount;
  
  // Payment fields
  final bool isPaidEvent;
  final double? eventAmount;
  final String? currency;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.isHouseEvent,
    this.eventImage,
    this.price,
    this.availableSeats,
    this.participantCount,
    this.isPaidEvent = false,
    this.eventAmount,
    this.currency,
  });

  // Create Event from backend API JSON response
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      location: json['location'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      eventImage: json['banner_url'] as String? ?? json['image_url'] as String?,
      isHouseEvent: false,
      price: (json['event_amount'] as num?)?.toDouble(),
      availableSeats: json['max_participants'] as int?,
      participantCount: json['current_participants'] as int?,
      // Payment fields
      isPaidEvent: json['is_paid_event'] as bool? ?? false,
      eventAmount: (json['event_amount'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'INR',
    );
  }

  // Convert Event to JSON for backend API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'location': location,
      'category': category,
      'banner_url': eventImage,
      'max_capacity': availableSeats,
      // Payment fields
      'is_paid_event': isPaidEvent,
      'event_amount': eventAmount,
      'currency': currency ?? 'INR',
    };
  }

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
  
  // Helper to format price display
  String get formattedPrice {
    if (!isPaidEvent || eventAmount == null) return 'Free';
    final currencySymbol = currency == 'INR' ? '₹' : currency ?? '';
    return '$currencySymbol${eventAmount!.toStringAsFixed(0)}';
  }
}

