import 'chat_message.dart';

enum ConversationType {
  direct, // One-on-one chat
  group,  // Group chat
}

class ChatConversation {
  final String id;
  final String title;
  final String? description;
  final ConversationType type;
  final List<String> participantIds;
  final List<String> participantNames;
  final List<String> participantAvatars;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime lastActivity;
  final bool isOnline;
  final String? groupAvatarUrl;
  final bool isPinned;
  final bool isMuted;

  const ChatConversation({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.participantIds,
    required this.participantNames,
    required this.participantAvatars,
    this.lastMessage,
    required this.unreadCount,
    required this.lastActivity,
    required this.isOnline,
    this.groupAvatarUrl,
    required this.isPinned,
    required this.isMuted,
  });

  ChatConversation copyWith({
    String? id,
    String? title,
    String? description,
    ConversationType? type,
    List<String>? participantIds,
    List<String>? participantNames,
    List<String>? participantAvatars,
    ChatMessage? lastMessage,
    int? unreadCount,
    DateTime? lastActivity,
    bool? isOnline,
    String? groupAvatarUrl,
    bool? isPinned,
    bool? isMuted,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      participantAvatars: participantAvatars ?? this.participantAvatars,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      lastActivity: lastActivity ?? this.lastActivity,
      isOnline: isOnline ?? this.isOnline,
      groupAvatarUrl: groupAvatarUrl ?? this.groupAvatarUrl,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  String get displayTitle {
    if (type == ConversationType.direct && participantNames.isNotEmpty) {
      return participantNames.first;
    }
    return title;
  }

  String get displayAvatar {
    if (type == ConversationType.direct && participantAvatars.isNotEmpty) {
      return participantAvatars.first;
    }
    return groupAvatarUrl ?? '';
  }

  String get lastMessagePreview {
    if (lastMessage == null) return 'No messages yet';
    
    switch (lastMessage!.type) {
      case MessageType.text:
        return lastMessage!.content;
      case MessageType.image:
        return '📷 Image';
      case MessageType.file:
        return '📎 ${lastMessage!.fileName ?? 'File'}';
    }
  }

  String get lastActivityTime {
    final now = DateTime.now();
    final difference = now.difference(lastActivity);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${lastActivity.day}/${lastActivity.month}';
    }
  }
}