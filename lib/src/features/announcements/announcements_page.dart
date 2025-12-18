import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import '../../shared/models/post.dart';
import '../../shared/services/posts_api_service.dart';
import '../../shared/utils/theme_colors.dart';
import 'admin/create_post_page.dart';
import 'widgets/post_card.dart';
import 'widgets/stories_row.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  late PostsApiService _apiService;
  List<PostWithCreator> _posts = [];
  List<StoryWithCreator> _stories = [];
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();
  
  // TODO: Replace with actual admin check from auth service
  bool get _isAdmin => true; // For now, show for all users

  @override
  void initState() {
    super.initState();
    // TODO: Get base URL and auth token from config/auth service
    _apiService = PostsApiService(
      baseUrl: ApiService.baseUrl,
      authToken: null, // Will be set from auth service
    );
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (!_isLoading && _hasMore) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Load stories and posts in parallel
      final results = await Future.wait([
        _apiService.getStories(),
        _apiService.getPosts(page: 1, pageSize: 20),
      ]);

      if (mounted) {
        setState(() {
          _stories = results[0] as List<StoryWithCreator>;
          final postsResponse = results[1] as PostsListResponse;
          _posts = postsResponse.posts;
          _currentPage = postsResponse.page;
          _hasMore = postsResponse.page < postsResponse.totalPages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _loadMorePosts() async {
    try {
      final postsResponse = await _apiService.getPosts(
        page: _currentPage + 1,
        pageSize: 20,
      );

      if (mounted) {
        setState(() {
          _posts.addAll(postsResponse.posts);
          _currentPage = postsResponse.page;
          _hasMore = postsResponse.page < postsResponse.totalPages;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load more posts: $e')),
        );
      }
    }
  }

  Future<void> _refresh() async {
    _currentPage = 1;
    _hasMore = true;
    await _loadData();
  }

  Future<void> _navigateToCreatePost() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const CreatePostPage(),
      ),
    );
    
    // Refresh feed if a post was created
    if (result == true) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Announcements',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: ThemeColors.surface(context),
        elevation: 0,
      ),
      // FAB for admin to create posts
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: _navigateToCreatePost,
              backgroundColor: ThemeColors.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                'Create Post',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            )
          : null,
      body: _isLoading && _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load announcements',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage ?? 'Unknown error',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // Stories section - always show for admins so they can create stories
                      if (_stories.isNotEmpty || _isAdmin)
                        SliverToBoxAdapter(
                          child: StoriesRow(
                            stories: _stories,
                            apiService: _apiService,
                            onRefresh: _refresh,
                            isAdmin: _isAdmin,
                          ),
                        ),

                      // Posts list
                      if (_posts.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: ThemeColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.photo_library_outlined,
                                    size: 64,
                                    color: ThemeColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No posts yet',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ThemeColors.text(context),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Be the first to share something!',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    color: ThemeColors.textSecondary(context),
                                  ),
                                ),
                                if (_isAdmin) ...[
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: _navigateToCreatePost,
                                    icon: const Icon(Icons.add),
                                    label: const Text('Create First Post'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < _posts.length) {
                                return PostCard(
                                  post: _posts[index],
                                  apiService: _apiService,
                                  onRefresh: _refresh,
                                );
                              } else if (_hasMore) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return null;
                            },
                            childCount: _posts.length + (_hasMore ? 1 : 0),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
