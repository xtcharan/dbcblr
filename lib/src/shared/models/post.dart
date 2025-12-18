import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

/// Content type for posts and stories
enum ContentType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
}

/// Storage class for media files
enum StorageClass {
  @JsonValue('STANDARD')
  standard,
  @JsonValue('NEARLINE')
  nearline,
  @JsonValue('COLDLINE')
  coldline,
  @JsonValue('ARCHIVE')
  archive,
}

/// Post model representing an announcement post
@JsonSerializable()
class Post {
  final String id;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'club_id')
  final String? clubId;
  @JsonKey(name: 'house_id')
  final String? houseId;

  // Content
  @JsonKey(name: 'content_type')
  final ContentType contentType;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @JsonKey(name: 'duration_seconds')
  final int? durationSeconds;
  final String description;
  final List<String> hashtags;

  // Metadata
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  // Storage lifecycle
  @JsonKey(name: 'archived_at')
  final DateTime? archivedAt;
  @JsonKey(name: 'storage_class')
  final StorageClass storageClass;

  // Metrics
  @JsonKey(name: 'like_count')
  final int likeCount;
  @JsonKey(name: 'comment_count')
  final int commentCount;
  @JsonKey(name: 'share_count')
  final int shareCount;
  @JsonKey(name: 'view_count')
  final int viewCount;

  const Post({
    required this.id,
    required this.createdBy,
    this.clubId,
    this.houseId,
    required this.contentType,
    this.imageUrl,
    this.videoUrl,
    this.thumbnailUrl,
    this.durationSeconds,
    required this.description,
    this.hashtags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.archivedAt,
    this.storageClass = StorageClass.standard,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.viewCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  /// Check if this post is archived
  bool get isArchived => archivedAt != null;

  /// Check if this post has media
  bool get hasMedia => imageUrl != null || videoUrl != null;

  /// Get time since posted
  Duration get timeSincePosted => DateTime.now().difference(createdAt);
}

/// Post with creator information
@JsonSerializable()
class PostWithCreator extends Post {
  final UserSummary creator;
  @JsonKey(name: 'is_liked_by_me')
  final bool isLikedByMe;
  @JsonKey(name: 'is_shared_by_me')
  final bool isSharedByMe;

  const PostWithCreator({
    required super.id,
    required super.createdBy,
    super.clubId,
    super.houseId,
    required super.contentType,
    super.imageUrl,
    super.videoUrl,
    super.thumbnailUrl,
    super.durationSeconds,
    required super.description,
    super.hashtags,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    super.archivedAt,
    super.storageClass,
    super.likeCount,
    super.commentCount,
    super.shareCount,
    super.viewCount,
    required this.creator,
    this.isLikedByMe = false,
    this.isSharedByMe = false,
  });

  factory PostWithCreator.fromJson(Map<String, dynamic> json) =>
      _$PostWithCreatorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PostWithCreatorToJson(this);
}

/// User summary for posts/stories
@JsonSerializable()
class UserSummary {
  final String id;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String role;

  const UserSummary({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.role,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$UserSummaryToJson(this);
}

/// Post comment
@JsonSerializable()
class PostComment {
  final String id;
  @JsonKey(name: 'post_id')
  final String postId;
  @JsonKey(name: 'user_id')
  final String userId;
  final String content;
  @JsonKey(name: 'parent_comment_id')
  final String? parentCommentId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  const PostComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    this.parentCommentId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) =>
      _$PostCommentFromJson(json);
  Map<String, dynamic> toJson() => _$PostCommentToJson(this);

  /// Get time since commented
  Duration get timeSinceCommented => DateTime.now().difference(createdAt);
}

/// Post comment with user info
@JsonSerializable()
class PostCommentWithUser extends PostComment {
  final UserSummary user;
  final List<PostCommentWithUser>? replies;

  const PostCommentWithUser({
    required super.id,
    required super.postId,
    required super.userId,
    required super.content,
    super.parentCommentId,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    required this.user,
    this.replies,
  });

  factory PostCommentWithUser.fromJson(Map<String, dynamic> json) =>
      _$PostCommentWithUserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PostCommentWithUserToJson(this);
}

/// Request to create a post
@JsonSerializable()
class CreatePostRequest {
  @JsonKey(name: 'club_id')
  final String? clubId;
  @JsonKey(name: 'house_id')
  final String? houseId;
  @JsonKey(name: 'content_type')
  final ContentType contentType;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @JsonKey(name: 'duration_seconds')
  final int? durationSeconds;
  final String description;
  final List<String> hashtags;

  const CreatePostRequest({
    this.clubId,
    this.houseId,
    required this.contentType,
    this.imageUrl,
    this.videoUrl,
    this.thumbnailUrl,
    this.durationSeconds,
    required this.description,
    this.hashtags = const [],
  });

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePostRequestToJson(this);
}

/// Paginated posts response
@JsonSerializable()
class PostsListResponse {
  final List<PostWithCreator> posts;
  final int page;
  @JsonKey(name: 'page_size')
  final int pageSize;
  @JsonKey(name: 'total_count')
  final int totalCount;
  @JsonKey(name: 'total_pages')
  final int totalPages;

  const PostsListResponse({
    required this.posts,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory PostsListResponse.fromJson(Map<String, dynamic> json) =>
      _$PostsListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PostsListResponseToJson(this);
}

/// Story model (24-hour ephemeral content)
@JsonSerializable()
class Story {
  final String id;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'club_id')
  final String? clubId;
  @JsonKey(name: 'house_id')
  final String? houseId;

  // Content
  @JsonKey(name: 'content_type')
  final ContentType contentType;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  @JsonKey(name: 'duration_seconds')
  final int? durationSeconds;
  final String? description;
  final List<String> hashtags;

  // Metadata
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  // Metrics
  @JsonKey(name: 'view_count')
  final int viewCount;
  @JsonKey(name: 'like_count')
  final int likeCount;

  const Story({
    required this.id,
    required this.createdBy,
    this.clubId,
    this.houseId,
    required this.contentType,
    this.imageUrl,
    this.videoUrl,
    required this.thumbnailUrl,
    this.durationSeconds,
    this.description,
    this.hashtags = const [],
    required this.createdAt,
    required this.expiresAt,
    this.viewCount = 0,
    this.likeCount = 0,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);

  /// Check if story is still active (not expired)
  bool get isActive => DateTime.now().isBefore(expiresAt);

  /// Get time remaining until expiry
  Duration get timeRemaining => expiresAt.difference(DateTime.now());

  /// Get progress (0.0 to 1.0) for 24hr timer
  double get progress {
    final elapsed = DateTime.now().difference(createdAt);
    const total = Duration(hours: 24);
    return (elapsed.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
  }
}

/// Story with creator info
@JsonSerializable()
class StoryWithCreator extends Story {
  final UserSummary creator;
  @JsonKey(name: 'is_liked_by_me')
  final bool isLikedByMe;
  @JsonKey(name: 'is_viewed_by_me')
  final bool isViewedByMe;
  @JsonKey(name: 'time_remaining_seconds')
  final int timeRemainingSeconds;

  const StoryWithCreator({
    required super.id,
    required super.createdBy,
    super.clubId,
    super.houseId,
    required super.contentType,
    super.imageUrl,
    super.videoUrl,
    required super.thumbnailUrl,
    super.durationSeconds,
    super.description,
    super.hashtags,
    required super.createdAt,
    required super.expiresAt,
    super.viewCount,
    super.likeCount,
    required this.creator,
    this.isLikedByMe = false,
    this.isViewedByMe = false,
    required this.timeRemainingSeconds,
  });

  factory StoryWithCreator.fromJson(Map<String, dynamic> json) =>
      _$StoryWithCreatorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StoryWithCreatorToJson(this);
}
