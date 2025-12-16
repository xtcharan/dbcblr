/// Schedule model representing a daily schedule item
/// Can be either 'official' (admin-created) or 'personal' (student-created)
class Schedule {
  final String id;
  final String title;
  final String? description;
  final DateTime scheduleDate;
  final String startTime;
  final String? endTime;
  final String? location;
  final String scheduleType; // 'official' or 'personal'
  final String createdBy;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Schedule({
    required this.id,
    required this.title,
    this.description,
    required this.scheduleDate,
    required this.startTime,
    this.endTime,
    this.location,
    required this.scheduleType,
    required this.createdBy,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a Schedule from JSON
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduleDate: DateTime.parse(json['schedule_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String?,
      location: json['location'] as String?,
      scheduleType: json['schedule_type'] as String? ?? 'personal',
      createdBy: json['created_by'] as String,
      userId: json['user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts Schedule to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'schedule_date': scheduleDate.toIso8601String().split('T')[0], // YYYY-MM-DD
      'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (location != null) 'location': location,
      'schedule_type': scheduleType,
      'created_by': createdBy,
      if (userId != null) 'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Returns true if this is an official (admin-created) schedule
  bool get isOfficial => scheduleType == 'official';

  /// Returns true if this is a personal schedule
  bool get isPersonal => scheduleType == 'personal';

  /// Formatted start time for display (e.g., "9:00 AM")
  String get formattedStartTime {
    try {
      final parts = startTime.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        String period = hour >= 12 ? 'PM' : 'AM';
        if (hour > 12) hour -= 12;
        if (hour == 0) hour = 12;
        return '${hour.toString()}:${minute.toString().padLeft(2, '0')} $period';
      }
    } catch (_) {}
    return startTime;
  }

  /// Formatted end time for display (e.g., "10:30 AM")
  String? get formattedEndTime {
    if (endTime == null) return null;
    try {
      final parts = endTime!.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        String period = hour >= 12 ? 'PM' : 'AM';
        if (hour > 12) hour -= 12;
        if (hour == 0) hour = 12;
        return '${hour.toString()}:${minute.toString().padLeft(2, '0')} $period';
      }
    } catch (_) {}
    return endTime;
  }

  /// Formatted time range for display (e.g., "9:00 AM - 10:30 AM")
  String get formattedTimeRange {
    if (formattedEndTime != null) {
      return '$formattedStartTime - $formattedEndTime';
    }
    return formattedStartTime;
  }

  /// Copy with modifications
  Schedule copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduleDate,
    String? startTime,
    String? endTime,
    String? location,
    String? scheduleType,
    String? createdBy,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Schedule(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      scheduleType: scheduleType ?? this.scheduleType,
      createdBy: createdBy ?? this.createdBy,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
