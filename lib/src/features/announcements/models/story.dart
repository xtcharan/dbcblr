import 'package:flutter/material.dart';

class Story {
  final String id;
  final String userName;
  final String avatarUrl;
  final String content; // emoji or text content
  final bool isViewed;
  final Color ringColor;
  final DateTime createdAt;

  Story({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.content,
    this.isViewed = false,
    required this.ringColor,
    required this.createdAt,
  });

  static List<Story> fakeList() {
    return [
      // Your Story (admin)
      Story(
        id: 'your_story',
        userName: 'Your Story',
        avatarUrl: 'https://via.placeholder.com/80',
        content: '➕',
        ringColor: Colors.grey,
        createdAt: DateTime.now(),
      ),
      // Club stories
      Story(
        id: '1',
        userName: 'Tech Club',
        avatarUrl: 'https://via.placeholder.com/80',
        content: '💻',
        ringColor: Colors.blue,
        createdAt: DateTime.now().subtract(Duration(hours: 1)),
      ),
      Story(
        id: '2',
        userName: 'Sports Club',
        avatarUrl: 'https://via.placeholder.com/80',
        content: '⚽',
        ringColor: Colors.green,
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
      ),
      Story(
        id: '3',
        userName: 'Music Club',
        avatarUrl: 'https://via.placeholder.com/80',
        content: '🎵',
        ringColor: Colors.purple,
        createdAt: DateTime.now().subtract(Duration(hours: 3)),
      ),
      // House stories
      Story(
        id: '4',
        userName: 'Blue House',
        avatarUrl: 'https://via.placeholder.com/80',
        content: '🏠',
        ringColor: Colors.blue,
        createdAt: DateTime.now().subtract(Duration(hours: 4)),
      ),
      Story(
        id: '5',
        userName: 'Red House',
        avatarUrl: 'https://via.placeholder.com/80',
        content: '🔥',
        ringColor: Colors.red,
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
      ),
    ];
  }
}