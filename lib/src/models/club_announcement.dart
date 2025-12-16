/// Club announcement model matching backend structure
class ClubAnnouncement {
  final String id;
  final String clubId;
  final String title;
  final String content;
  final String priority; // "low", "normal", "high", "urgent"
  final bool isPinned;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClubAnnouncement({
    required this.id,
    required this.clubId,
    required this.title,
    required this.content,
    required this.priority,
    required this.isPinned,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClubAnnouncement.fromJson(Map<String, dynamic> json) {
    return ClubAnnouncement(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      priority: json['priority'] as String? ?? 'normal',
      isPinned: json['is_pinned'] as bool? ?? false,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'club_id': clubId,
      'title': title,
      'content': content,
      'priority': priority,
      'is_pinned': isPinned,
      if (createdBy != null) 'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper getters
  bool get isUrgent => priority == 'urgent';
  bool get isHigh => priority == 'high';

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}
