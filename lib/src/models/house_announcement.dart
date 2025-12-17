/// House announcement model with likes and comments support
class HouseAnnouncement {
  final String id;
  final String houseId;
  final String title;
  final String content;
  final String? createdBy;
  final String authorName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likeCount;
  final int commentCount;
  final bool isLikedByMe;

  const HouseAnnouncement({
    required this.id,
    required this.houseId,
    required this.title,
    required this.content,
    this.createdBy,
    this.authorName = 'Unknown',
    required this.createdAt,
    required this.updatedAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLikedByMe = false,
  });

  factory HouseAnnouncement.fromJson(Map<String, dynamic> json) {
    return HouseAnnouncement(
      id: json['id'] ?? '',
      houseId: json['house_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdBy: json['created_by'],
      authorName: json['author_name'] ?? 'Unknown',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      isLikedByMe: json['is_liked_by_me'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }

  /// Get relative time string (e.g., "2 hours ago")
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

/// Comment on a house announcement
class AnnouncementComment {
  final String id;
  final String announcementId;
  final String userId;
  final String content;
  final String userName;
  final String avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AnnouncementComment({
    required this.id,
    required this.announcementId,
    required this.userId,
    required this.content,
    this.userName = 'Unknown',
    this.avatarUrl = '',
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnnouncementComment.fromJson(Map<String, dynamic> json) {
    return AnnouncementComment(
      id: json['id'] ?? '',
      announcementId: json['announcement_id'] ?? '',
      userId: json['user_id'] ?? '',
      content: json['content'] ?? '',
      userName: json['user_name'] ?? 'Unknown',
      avatarUrl: json['avatar_url'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}
