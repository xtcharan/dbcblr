import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/utils/theme_colors.dart';
import 'models/chat_conversation.dart';
import 'models/chat_message.dart';
import 'data/chat_data.dart';

class ChatDetailPage extends StatefulWidget {
  final ChatConversation conversation;

  const ChatDetailPage({super.key, required this.conversation});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    setState(() {
      _messages = ChatData.getMessagesForConversation(widget.conversation.id);
    });
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'Me',
      senderAvatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
      conversationId: widget.conversation.id,
      content: content,
      type: MessageType.text,
      status: MessageStatus.sending,
      timestamp: DateTime.now(),
      isMe: true,
    );

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate message sent
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        final index = _messages.indexWhere((m) => m.id == newMessage.id);
        if (index != -1) {
          _messages[index] = newMessage.copyWith(status: MessageStatus.sent);
        }
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.background(context),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: ThemeColors.text(context),
          ),
        ),
        title: Row(
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: widget.conversation.displayAvatar.isNotEmpty
                    ? Image.network(
                        widget.conversation.displayAvatar,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
            const SizedBox(width: 12),
            // Title and status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.displayTitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.text(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.conversation.type == ConversationType.direct)
                    Text(
                      widget.conversation.isOnline ? 'Online' : 'Offline',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: widget.conversation.isOnline
                            ? Colors.green
                            : ThemeColors.textSecondary(context),
                      ),
                    )
                  else
                    Text(
                      '${widget.conversation.participantNames.length} members',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: ThemeColors.textSecondary(context),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showChatInfo,
            icon: Icon(
              Icons.info_outline,
              color: ThemeColors.text(context),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: ThemeColors.textSecondary(context),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: ThemeColors.textSecondary(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: ThemeColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isFirstInGroup = index == 0 ||
                          _messages[index - 1].senderId != message.senderId ||
                          message.timestamp.difference(_messages[index - 1].timestamp).inMinutes > 5;
                      
                      return _buildMessageBubble(message, isFirstInGroup);
                    },
                  ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.surface(context),
              border: Border(
                top: BorderSide(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.cardBackground(context),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: ThemeColors.cardBorder(context),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: ThemeColors.text(context)),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: 4,
                      minLines: 1,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ThemeColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ThemeColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.conversation.type == ConversationType.group 
            ? Icons.group 
            : Icons.person,
        size: 20,
        color: ThemeColors.primary,
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isFirstInGroup) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
        top: isFirstInGroup ? 8 : 2,
      ),
      child: Row(
        mainAxisAlignment: message.isMe 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe && isFirstInGroup) ...[
            // Sender avatar
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              child: ClipOval(
                child: Image.network(
                  message.senderAvatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: ThemeColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ] else if (!message.isMe) ...[
            const SizedBox(width: 40), // Space for avatar
          ],
          
          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe 
                    ? ThemeColors.primary 
                    : ThemeColors.cardBackground(context),
                borderRadius: BorderRadius.circular(20),
                border: !message.isMe ? Border.all(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe && widget.conversation.type == ConversationType.group && isFirstInGroup)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.senderName,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.primary,
                        ),
                      ),
                    ),
                  Text(
                    message.content,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: message.isMe 
                          ? Colors.white 
                          : ThemeColors.text(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.timeString,
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          color: message.isMe 
                              ? Colors.white.withValues(alpha: 0.7)
                              : ThemeColors.textSecondary(context),
                        ),
                      ),
                      if (message.isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.statusIcon,
                          size: 12,
                          color: message.getStatusColor(context),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.cardBackground(context),
        title: Text(
          'Chat Info',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        content: Text(
          'Chat info and settings will be available here.',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.urbanist(
                color: ThemeColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}