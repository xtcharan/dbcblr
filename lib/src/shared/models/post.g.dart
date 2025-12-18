// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
  id: json['id'] as String,
  createdBy: json['created_by'] as String,
  clubId: json['club_id'] as String?,
  houseId: json['house_id'] as String?,
  contentType: $enumDecode(_$ContentTypeEnumMap, json['content_type']),
  imageUrl: json['image_url'] as String?,
  videoUrl: json['video_url'] as String?,
  thumbnailUrl: json['thumbnail_url'] as String?,
  durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
  description: json['description'] as String,
  hashtags:
      (json['hashtags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  archivedAt: json['archived_at'] == null
      ? null
      : DateTime.parse(json['archived_at'] as String),
  storageClass:
      $enumDecodeNullable(_$StorageClassEnumMap, json['storage_class']) ??
      StorageClass.standard,
  likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
  commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
  shareCount: (json['share_count'] as num?)?.toInt() ?? 0,
  viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
  'id': instance.id,
  'created_by': instance.createdBy,
  'club_id': instance.clubId,
  'house_id': instance.houseId,
  'content_type': _$ContentTypeEnumMap[instance.contentType]!,
  'image_url': instance.imageUrl,
  'video_url': instance.videoUrl,
  'thumbnail_url': instance.thumbnailUrl,
  'duration_seconds': instance.durationSeconds,
  'description': instance.description,
  'hashtags': instance.hashtags,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'archived_at': instance.archivedAt?.toIso8601String(),
  'storage_class': _$StorageClassEnumMap[instance.storageClass]!,
  'like_count': instance.likeCount,
  'comment_count': instance.commentCount,
  'share_count': instance.shareCount,
  'view_count': instance.viewCount,
};

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.image: 'image',
  ContentType.video: 'video',
};

const _$StorageClassEnumMap = {
  StorageClass.standard: 'STANDARD',
  StorageClass.nearline: 'NEARLINE',
  StorageClass.coldline: 'COLDLINE',
  StorageClass.archive: 'ARCHIVE',
};

PostWithCreator _$PostWithCreatorFromJson(Map<String, dynamic> json) =>
    PostWithCreator(
      id: json['id'] as String,
      createdBy: json['created_by'] as String,
      clubId: json['club_id'] as String?,
      houseId: json['house_id'] as String?,
      contentType: $enumDecode(_$ContentTypeEnumMap, json['content_type']),
      imageUrl: json['image_url'] as String?,
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      description: json['description'] as String,
      hashtags:
          (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      archivedAt: json['archived_at'] == null
          ? null
          : DateTime.parse(json['archived_at'] as String),
      storageClass:
          $enumDecodeNullable(_$StorageClassEnumMap, json['storage_class']) ??
          StorageClass.standard,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
      shareCount: (json['share_count'] as num?)?.toInt() ?? 0,
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      creator: UserSummary.fromJson(json['creator'] as Map<String, dynamic>),
      isLikedByMe: json['is_liked_by_me'] as bool? ?? false,
      isSharedByMe: json['is_shared_by_me'] as bool? ?? false,
    );

Map<String, dynamic> _$PostWithCreatorToJson(PostWithCreator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_by': instance.createdBy,
      'club_id': instance.clubId,
      'house_id': instance.houseId,
      'content_type': _$ContentTypeEnumMap[instance.contentType]!,
      'image_url': instance.imageUrl,
      'video_url': instance.videoUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'duration_seconds': instance.durationSeconds,
      'description': instance.description,
      'hashtags': instance.hashtags,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'archived_at': instance.archivedAt?.toIso8601String(),
      'storage_class': _$StorageClassEnumMap[instance.storageClass]!,
      'like_count': instance.likeCount,
      'comment_count': instance.commentCount,
      'share_count': instance.shareCount,
      'view_count': instance.viewCount,
      'creator': instance.creator,
      'is_liked_by_me': instance.isLikedByMe,
      'is_shared_by_me': instance.isSharedByMe,
    };

UserSummary _$UserSummaryFromJson(Map<String, dynamic> json) => UserSummary(
  id: json['id'] as String,
  fullName: json['full_name'] as String,
  avatarUrl: json['avatar_url'] as String?,
  role: json['role'] as String,
);

Map<String, dynamic> _$UserSummaryToJson(UserSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'role': instance.role,
    };

PostComment _$PostCommentFromJson(Map<String, dynamic> json) => PostComment(
  id: json['id'] as String,
  postId: json['post_id'] as String,
  userId: json['user_id'] as String,
  content: json['content'] as String,
  parentCommentId: json['parent_comment_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$PostCommentToJson(PostComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'user_id': instance.userId,
      'content': instance.content,
      'parent_comment_id': instance.parentCommentId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

PostCommentWithUser _$PostCommentWithUserFromJson(Map<String, dynamic> json) =>
    PostCommentWithUser(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      parentCommentId: json['parent_comment_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      user: UserSummary.fromJson(json['user'] as Map<String, dynamic>),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => PostCommentWithUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostCommentWithUserToJson(
  PostCommentWithUser instance,
) => <String, dynamic>{
  'id': instance.id,
  'post_id': instance.postId,
  'user_id': instance.userId,
  'content': instance.content,
  'parent_comment_id': instance.parentCommentId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'user': instance.user,
  'replies': instance.replies,
};

CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) =>
    CreatePostRequest(
      clubId: json['club_id'] as String?,
      houseId: json['house_id'] as String?,
      contentType: $enumDecode(_$ContentTypeEnumMap, json['content_type']),
      imageUrl: json['image_url'] as String?,
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      description: json['description'] as String,
      hashtags:
          (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CreatePostRequestToJson(CreatePostRequest instance) =>
    <String, dynamic>{
      'club_id': instance.clubId,
      'house_id': instance.houseId,
      'content_type': _$ContentTypeEnumMap[instance.contentType]!,
      'image_url': instance.imageUrl,
      'video_url': instance.videoUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'duration_seconds': instance.durationSeconds,
      'description': instance.description,
      'hashtags': instance.hashtags,
    };

PostsListResponse _$PostsListResponseFromJson(Map<String, dynamic> json) =>
    PostsListResponse(
      posts: (json['posts'] as List<dynamic>)
          .map((e) => PostWithCreator.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      totalCount: (json['total_count'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$PostsListResponseToJson(PostsListResponse instance) =>
    <String, dynamic>{
      'posts': instance.posts,
      'page': instance.page,
      'page_size': instance.pageSize,
      'total_count': instance.totalCount,
      'total_pages': instance.totalPages,
    };

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
  id: json['id'] as String,
  createdBy: json['created_by'] as String,
  clubId: json['club_id'] as String?,
  houseId: json['house_id'] as String?,
  contentType: $enumDecode(_$ContentTypeEnumMap, json['content_type']),
  imageUrl: json['image_url'] as String?,
  videoUrl: json['video_url'] as String?,
  thumbnailUrl: json['thumbnail_url'] as String,
  durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
  description: json['description'] as String?,
  hashtags:
      (json['hashtags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['created_at'] as String),
  expiresAt: DateTime.parse(json['expires_at'] as String),
  viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
  likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
  'id': instance.id,
  'created_by': instance.createdBy,
  'club_id': instance.clubId,
  'house_id': instance.houseId,
  'content_type': _$ContentTypeEnumMap[instance.contentType]!,
  'image_url': instance.imageUrl,
  'video_url': instance.videoUrl,
  'thumbnail_url': instance.thumbnailUrl,
  'duration_seconds': instance.durationSeconds,
  'description': instance.description,
  'hashtags': instance.hashtags,
  'created_at': instance.createdAt.toIso8601String(),
  'expires_at': instance.expiresAt.toIso8601String(),
  'view_count': instance.viewCount,
  'like_count': instance.likeCount,
};

StoryWithCreator _$StoryWithCreatorFromJson(Map<String, dynamic> json) =>
    StoryWithCreator(
      id: json['id'] as String,
      createdBy: json['created_by'] as String,
      clubId: json['club_id'] as String?,
      houseId: json['house_id'] as String?,
      contentType: $enumDecode(_$ContentTypeEnumMap, json['content_type']),
      imageUrl: json['image_url'] as String?,
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      description: json['description'] as String?,
      hashtags:
          (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      creator: UserSummary.fromJson(json['creator'] as Map<String, dynamic>),
      isLikedByMe: json['is_liked_by_me'] as bool? ?? false,
      isViewedByMe: json['is_viewed_by_me'] as bool? ?? false,
      timeRemainingSeconds: (json['time_remaining_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$StoryWithCreatorToJson(StoryWithCreator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_by': instance.createdBy,
      'club_id': instance.clubId,
      'house_id': instance.houseId,
      'content_type': _$ContentTypeEnumMap[instance.contentType]!,
      'image_url': instance.imageUrl,
      'video_url': instance.videoUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'duration_seconds': instance.durationSeconds,
      'description': instance.description,
      'hashtags': instance.hashtags,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
      'view_count': instance.viewCount,
      'like_count': instance.likeCount,
      'creator': instance.creator,
      'is_liked_by_me': instance.isLikedByMe,
      'is_viewed_by_me': instance.isViewedByMe,
      'time_remaining_seconds': instance.timeRemainingSeconds,
    };
