/// Club award model matching backend structure
class ClubAward {
  final String id;
  final String clubId;
  final String awardName;
  final String? description;
  final String? position; // "1st", "2nd", "3rd", "Winner", etc.
  final double? prizeAmount;
  final String? eventName;
  final DateTime? awardedDate;
  final String? certificateUrl;
  final DateTime createdAt;

  const ClubAward({
    required this.id,
    required this.clubId,
    required this.awardName,
    this.description,
    this.position,
    this.prizeAmount,
    this.eventName,
    this.awardedDate,
    this.certificateUrl,
    required this.createdAt,
  });

  factory ClubAward.fromJson(Map<String, dynamic> json) {
    return ClubAward(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      awardName: json['award_name'] as String,
      description: json['description'] as String?,
      position: json['position'] as String?,
      prizeAmount: (json['prize_amount'] as num?)?.toDouble(),
      eventName: json['event_name'] as String?,
      awardedDate: json['awarded_date'] != null
          ? DateTime.parse(json['awarded_date'] as String)
          : null,
      certificateUrl: json['certificate_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'club_id': clubId,
      'award_name': awardName,
      if (description != null) 'description': description,
      if (position != null) 'position': position,
      if (prizeAmount != null) 'prize_amount': prizeAmount,
      if (eventName != null) 'event_name': eventName,
      if (awardedDate != null) 'awarded_date': awardedDate!.toIso8601String(),
      if (certificateUrl != null) 'certificate_url': certificateUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Helper getters
  String get formattedPrize {
    if (prizeAmount == null) return '';
    return '₹${prizeAmount!.toStringAsFixed(0)}';
  }

  String get formattedDate {
    if (awardedDate == null) return '';
    return '${awardedDate!.day}/${awardedDate!.month}/${awardedDate!.year}';
  }

  String get displayPosition {
    if (position == null) return 'Award';
    return position!;
  }
}
