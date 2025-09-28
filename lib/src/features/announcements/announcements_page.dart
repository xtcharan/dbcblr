import 'package:flutter/material.dart';
import 'models/story.dart';
import 'models/post.dart';
import 'widgets/stories_row.dart';
import 'widgets/post_card.dart';
import 'widgets/story_viewer.dart';
import 'widgets/comment_sheet.dart';

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
