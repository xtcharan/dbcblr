/// House event model
class HouseEvent {
  final String id;
  final String houseId;
  final String title;
  final String? description;
  final DateTime eventDate;
  final String? startTime;
  final String? endTime;
  final String? venue;
  final int? maxParticipants;
  final DateTime? registrationDeadline;
  final String status;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int enrollmentCount;
  final bool isEnrolled;

  const HouseEvent({
    required this.id,
    required this.houseId,
    required this.title,
    this.description,
    required this.eventDate,
    this.startTime,
    this.endTime,
    this.venue,
    this.maxParticipants,
    this.registrationDeadline,
    this.status = 'open',
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.enrollmentCount = 0,
    this.isEnrolled = false,
  });

  factory HouseEvent.fromJson(Map<String, dynamic> json) {
    return HouseEvent(
      id: json['id'] ?? '',
      houseId: json['house_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      eventDate: json['event_date'] != null
          ? DateTime.parse(json['event_date'])
          : DateTime.now(),
      startTime: json['start_time'],
      endTime: json['end_time'],
      venue: json['venue'],
      maxParticipants: json['max_participants'],
      registrationDeadline: json['registration_deadline'] != null
          ? DateTime.parse(json['registration_deadline'])
          : null,
      status: json['status'] ?? 'open',
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      enrollmentCount: json['enrollment_count'] ?? 0,
      isEnrolled: json['is_enrolled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'event_date': eventDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'venue': venue,
      'max_participants': maxParticipants,
      'registration_deadline': registrationDeadline?.toIso8601String().split('T')[0],
    };
  }

  /// Check if event is open for registration
  bool get isOpen => status.toLowerCase() == 'open';

  /// Check if event is full
  bool get isFull => maxParticipants != null && enrollmentCount >= maxParticipants!;

  /// Get formatted date string
  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${eventDate.day} ${months[eventDate.month - 1]} ${eventDate.year}';
  }

  /// Get time range string
  String get timeRange {
    if (startTime == null) return '';
    if (endTime == null) return startTime!;
    return '$startTime - $endTime';
  }
}
