import 'package:flutter/material.dart';
import '../models/story.dart';
import 'story_item.dart';

class StoriesRow extends StatelessWidget {
  final List<Story> stories;
  final Function(Story)? onStoryTap;

  const StoriesRow({
    super.key,
    required this.stories,
    this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StoryItem(
              story: stories[index],
              onTap: () => onStoryTap?.call(stories[index]),
            ),
          );
        },
      ),
    );
  }
}