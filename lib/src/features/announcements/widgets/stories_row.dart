import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/post.dart';
import '../../../shared/services/posts_api_service.dart';
import '../../../shared/utils/theme_colors.dart';
import '../admin/create_story_page.dart';

class StoriesRow extends StatelessWidget {
  final List<StoryWithCreator> stories;
  final PostsApiService apiService;
  final VoidCallback? onRefresh;
  final bool isAdmin;

  const StoriesRow({
    super.key,
    required this.stories,
    required this.apiService,
    this.onRefresh,
    this.isAdmin = true, // TODO: Get from auth service
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: stories.length + (isAdmin ? 1 : 0), // +1 for "Add Story" option
        itemBuilder: (context, index) {
          // First item is "Add Story" for admins
          if (isAdmin && index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _AddStoryButton(onRefresh: onRefresh),
            );
          }
          
          final storyIndex = isAdmin ? index - 1 : index;
          final story = stories[storyIndex];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _StoryCircle(
              story: story,
              apiService: apiService,
              onRefresh: onRefresh,
            ),
          );
        },
      ),
    );
  }
}

class _AddStoryButton extends StatelessWidget {
  final VoidCallback? onRefresh;

  const _AddStoryButton({this.onRefresh});

  Future<void> _navigateToCreateStory(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const CreateStoryPage(),
      ),
    );
    
    if (result == true) {
      onRefresh?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToCreateStory(context),
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple.shade400,
                        Colors.pink.shade400,
                        Colors.orange.shade400,
                      ],
                    ),
                  ),
                ),
                // Inner circle with plus
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeColors.surface(context),
                    border: Border.all(
                      color: ThemeColors.background(context),
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 28,
                    color: ThemeColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Your Story',
              style: GoogleFonts.urbanist(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ThemeColors.text(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


class _StoryCircle extends StatelessWidget {
  final StoryWithCreator story;
  final PostsApiService apiService;
  final VoidCallback? onRefresh;

  const _StoryCircle({
    required this.story,
    required this.apiService,
    this.onRefresh,
  });

  void _viewStory(BuildContext context) {
    // Track view
    apiService.trackStoryView(story.id);
    
    // Show story viewer dialog
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (context) => _StoryViewer(
        story: story,
        apiService: apiService,
        onClose: () {
          Navigator.of(context).pop();
          onRefresh?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = story.progress;
    final isViewed = story.isViewedByMe;

    return GestureDetector(
      onTap: () => _viewStory(context),
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Progress ring
                SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isViewed ? Colors.grey[400]! : Colors.blue,
                    ),
                  ),
                ),
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(story.thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              story.creator.fullName.length > 10
                  ? '${story.creator.fullName.substring(0, 10)}...'
                  : story.creator.fullName,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryViewer extends StatefulWidget {
  final StoryWithCreator story;
  final PostsApiService apiService;
  final VoidCallback onClose;

  const _StoryViewer({
    required this.story,
    required this.apiService,
    required this.onClose,
  });

  @override
  State<_StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<_StoryViewer> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.story.isLikedByMe;
  }

  Future<void> _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
    });

    try {
      await widget.apiService.toggleStoryLike(widget.story.id);
    } catch (e) {
      // Revert on error
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  String _formatTimeRemaining(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h remaining';
    } else if (minutes > 0) {
      return '${minutes}m remaining';
    } else {
      return 'Expiring soon';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Story content
            Center(
              child: widget.story.contentType == ContentType.image &&
                      widget.story.imageUrl != null
                  ? Image.network(
                      widget.story.imageUrl!,
                      fit: BoxFit.contain,
                    )
                  : widget.story.contentType == ContentType.video &&
                          widget.story.videoUrl != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              widget.story.thumbnailUrl,
                              fit: BoxFit.contain,
                            ),
                            const Icon(
                              Icons.play_circle_outline,
                              size: 80,
                              color: Colors.white,
                            ),
                          ],
                        )
                      : Container(
                          color: Colors.grey[900],
                          child: Center(
                            child: Text(
                              widget.story.description ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
            ),

            // Top bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: widget.story.creator.avatarUrl != null
                            ? NetworkImage(widget.story.creator.avatarUrl!)
                            : null,
                        child: widget.story.creator.avatarUrl == null
                            ? Text(widget.story.creator.fullName[0])
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.story.creator.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatTimeRemaining(widget.story.timeRemainingSeconds),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom actions
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.story.description != null)
                        Expanded(
                          child: Text(
                            widget.story.description!,
                            style: const TextStyle(color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const Spacer(),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.white,
                              size: 32,
                            ),
                            onPressed: _toggleLike,
                          ),
                          Text(
                            '${widget.story.likeCount + (_isLiked && !widget.story.isLikedByMe ? 1 : 0)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: null,
                          ),
                          Text(
                            '${widget.story.viewCount}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}