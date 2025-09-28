import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryItem extends StatelessWidget {
  final Story story;
  final VoidCallback? onTap;

  const StoryItem({
    super.key,
    required this.story,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isYourStory = story.id == 'your_story';
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: story.isViewed || isYourStory
                  ? null
                  : LinearGradient(
                      colors: [
                        story.ringColor,
                        story.ringColor.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              border: story.isViewed || isYourStory
                  ? Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 2)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: isYourStory
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(story.avatarUrl),
                                  fit: BoxFit.cover,
                                ),
                          color: isYourStory ? Colors.grey[300] : null,
                        ),
                        child: isYourStory
                            ? Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey[600],
                                  size: 24,
                                ),
                              )
                            : Center(
                                child: Text(
                                  story.content,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                      ),
                      if (isYourStory)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 80,
            child: Text(
              story.userName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}