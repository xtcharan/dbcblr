import 'package:flutter/material.dart';
import 'models/story.dart';
import 'models/post.dart';
import 'widgets/stories_row.dart';
import 'widgets/post_card.dart';
import 'widgets/story_viewer.dart';
import 'widgets/comment_sheet.dart';
import '../chat/chat_page.dart';
import '../../shared/utils/theme_colors.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  late List<Story> _stories;
  late List<Post> _posts;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _stories = Story.fakeList();
      _posts = Post.fakeList();
    });
  }

  Future<void> _refreshFeed() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _loadData();
  }

  void _openStoryViewer(Story story) {
    final storyIndex = _stories.indexOf(story);
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StoryViewer(stories: _stories, initialIndex: storyIndex),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void _openCommentSheet(Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentSheet(post: post),
    );
  }

  void _handleLike(Post post) {
    // Update the post in the list
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      setState(() {
        _posts[index] = post;
      });
    }
  }

  void _openChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Announcements',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          // Chat button in the top-right corner
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _openChat,
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 26,
                    color: ThemeColors.text(context),
                  ),
                  // Unread messages indicator (you can make this dynamic)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              tooltip: 'Messages',
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshFeed,
        child: CustomScrollView(
          slivers: [
            // Stories section
            SliverToBoxAdapter(
              child: StoriesRow(
                stories: _stories,
                onStoryTap: _openStoryViewer,
              ),
            ),
            
            // Posts section
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PostCard(
                    post: _posts[index],
                    onLikePressed: _handleLike,
                    onCommentPressed: _openCommentSheet,
                  );
                },
                childCount: _posts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
