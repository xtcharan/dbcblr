import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

/// API service for posts and stories
class PostsApiService {
  final String baseUrl;
  final String? authToken;

  PostsApiService({
    required this.baseUrl,
    this.authToken,
  });

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  // ============================================================================
  // POSTS
  // ============================================================================

  /// Get list of posts with pagination
  Future<PostsListResponse> getPosts({
    int page = 1,
    int pageSize = 20,
    String? hashtag,
    String? clubId,
    String? houseId,
    String? search,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'page_size': pageSize.toString(),
      if (hashtag != null) 'hashtag': hashtag,
      if (clubId != null) 'club_id': clubId,
      if (houseId != null) 'house_id': houseId,
      if (search != null) 'q': search,
    };

    final uri = Uri.parse('$baseUrl/posts').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PostsListResponse.fromJson(json['data']);
    } else {
      throw Exception('Failed to load posts: ${response.body}');
    }
  }

  /// Get single post by ID
  Future<PostWithCreator> getPost(String postId) async {
    final uri = Uri.parse('$baseUrl/posts/$postId');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PostWithCreator.fromJson(json['data']);
    } else {
      throw Exception('Failed to load post: ${response.body}');
    }
  }

  /// Create a new post (admin only)
  Future<Post> createPost(CreatePostRequest request) async {
    final uri = Uri.parse('$baseUrl/admin/posts');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Post.fromJson(json['data']);
    } else {
      throw Exception('Failed to create post: ${response.body}');
    }
  }

  /// Update a post (admin only)
  Future<void> updatePost(
    String postId, {
    String? description,
    List<String>? hashtags,
  }) async {
    final uri = Uri.parse('$baseUrl/admin/posts/$postId');
    final body = {
      if (description != null) 'description': description,
      if (hashtags != null) 'hashtags': hashtags,
    };

    final response = await http.put(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update post: ${response.body}');
    }
  }

  /// Soft delete a post (admin only)
  Future<void> deletePost(String postId) async {
    final uri = Uri.parse('$baseUrl/admin/posts/$postId');
    final response = await http.delete(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post: ${response.body}');
    }
  }

  /// Hard delete a post permanently (admin only)
  Future<void> hardDeletePost(String postId) async {
    final uri = Uri.parse('$baseUrl/admin/posts/$postId/hard');
    final response = await http.delete(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to hard delete post: ${response.body}');
    }
  }

  /// Toggle like on a post
  Future<bool> toggleLike(String postId) async {
    final uri = Uri.parse('$baseUrl/posts/$postId/like');
    final response = await http.post(uri, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']['liked'] as bool;
    } else {
      throw Exception('Failed to like post: ${response.body}');
    }
  }

  /// Add comment to a post
  Future<PostComment> addComment(String postId, String content) async {
    final uri = Uri.parse('$baseUrl/posts/$postId/comment');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return PostComment.fromJson(json['data']);
    } else {
      throw Exception('Failed to add comment: ${response.body}');
    }
  }

  /// Delete a comment
  Future<void> deleteComment(String postId, String commentId) async {
    final uri = Uri.parse('$baseUrl/posts/$postId/comments/$commentId');
    final response = await http.delete(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment: ${response.body}');
    }
  }

  /// Track a share
  Future<void> trackShare(String postId, {String? shareMethod}) async {
    final uri = Uri.parse('$baseUrl/posts/$postId/share');
    final body = {
      if (shareMethod != null) 'share_method': shareMethod,
    };

    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to track share: ${response.body}');
    }
  }

  /// Track a view
  Future<void> trackView(String postId) async {
    final uri = Uri.parse('$baseUrl/posts/$postId/view');
    final response = await http.post(uri, headers: _headers);

    // Silently fail for views (non-critical)
    if (response.statusCode != 200) {
      print('Warning: Failed to track view');
    }
  }

  // ============================================================================
  // STORIES
  // ============================================================================

  /// Get list of active stories
  Future<List<StoryWithCreator>> getStories() async {
    final uri = Uri.parse('$baseUrl/stories');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final storiesJson = json['data']['stories'] as List;
      return storiesJson
          .map((story) => StoryWithCreator.fromJson(story))
          .toList();
    } else {
      throw Exception('Failed to load stories: ${response.body}');
    }
  }

  /// Create a new story (admin only)
  Future<Story> createStory({
    required ContentType contentType,
    String? imageUrl,
    String? videoUrl,
    required String thumbnailUrl,
    int? durationSeconds,
    String? description,
    List<String>? hashtags,
    String? clubId,
    String? houseId,
  }) async {
    final uri = Uri.parse('$baseUrl/admin/stories');
    final body = {
      'content_type': contentType.name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (videoUrl != null) 'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (description != null) 'description': description,
      if (hashtags != null) 'hashtags': hashtags,
      if (clubId != null) 'club_id': clubId,
      if (houseId != null) 'house_id': houseId,
    };

    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return Story.fromJson(json['data']);
    } else {
      throw Exception('Failed to create story: ${response.body}');
    }
  }

  /// Hard delete a story (admin only)
  Future<void> hardDeleteStory(String storyId) async {
    final uri = Uri.parse('$baseUrl/admin/stories/$storyId/hard');
    final response = await http.delete(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete story: ${response.body}');
    }
  }

  /// Toggle like on a story
  Future<bool> toggleStoryLike(String storyId) async {
    final uri = Uri.parse('$baseUrl/stories/$storyId/like');
    final response = await http.post(uri, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']['liked'] as bool;
    } else {
      throw Exception('Failed to like story: ${response.body}');
    }
  }

  /// Track story view
  Future<void> trackStoryView(String storyId) async {
    final uri = Uri.parse('$baseUrl/stories/$storyId/view');
    final response = await http.post(uri, headers: _headers);

    // Silently fail for views (non-critical)
    if (response.statusCode != 200) {
      print('Warning: Failed to track story view');
    }
  }
}
