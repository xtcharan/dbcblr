import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/utils/theme_colors.dart';
import 'models/chat_conversation.dart';
import 'data/chat_data.dart';
import 'widgets/conversation_item.dart';
import 'chat_detail_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<ChatConversation> _conversations = [];
  List<ChatConversation> _filteredConversations = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadConversations();
    _searchController.addListener(_filterConversations);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadConversations() {
    setState(() {
      _conversations = ChatData.getConversations();
      _filteredConversations = _conversations;
    });
  }

  void _filterConversations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredConversations = _conversations;
      } else {
        _filteredConversations = _conversations
            .where((conversation) =>
                conversation.displayTitle.toLowerCase().contains(query) ||
                conversation.lastMessagePreview.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  List<ChatConversation> get _pinnedConversations =>
      _filteredConversations.where((c) => c.isPinned).toList();

  List<ChatConversation> get _groupConversations =>
      _filteredConversations.where((c) => c.type == ConversationType.group).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.background(context),
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: ThemeColors.text(context)),
                decoration: InputDecoration(
                  hintText: 'Search chats...',
                  hintStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                  border: InputBorder.none,
                ),
              )
            : Text(
                'Chats',
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.text(context),
                ),
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: Icon(
                Icons.search,
                color: ThemeColors.text(context),
              ),
            ),
          if (_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
              icon: Icon(
                Icons.close,
                color: ThemeColors.text(context),
              ),
            ),
          IconButton(
            onPressed: _showNewChatOptions,
            icon: Icon(
              Icons.edit_outlined,
              color: ThemeColors.text(context),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: ThemeColors.primary,
          unselectedLabelColor: ThemeColors.textSecondary(context),
          indicatorColor: ThemeColors.primary,
          labelStyle: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Groups'),
            Tab(text: 'Pinned'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Chats
          _buildChatList(_filteredConversations),
          // Groups
          _buildChatList(_groupConversations),
          // Pinned
          _buildChatList(_pinnedConversations),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewChatOptions,
        backgroundColor: ThemeColors.primary,
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildChatList(List<ChatConversation> conversations) {
    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: ThemeColors.textSecondary(context),
            ),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeColors.text(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation to connect with others',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: ThemeColors.textSecondary(context),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return ConversationItem(
          conversation: conversation,
          onTap: () => _openChat(conversation),
          onLongPress: () => _showConversationOptions(conversation),
        );
      },
    );
  }

  void _openChat(ChatConversation conversation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(conversation: conversation),
      ),
    );
  }

  void _showConversationOptions(ChatConversation conversation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.cardBackground(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                conversation.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                color: ThemeColors.primary,
              ),
              title: Text(
                conversation.isPinned ? 'Unpin Chat' : 'Pin Chat',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.text(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle pin/unpin
                _togglePin(conversation);
              },
            ),
            ListTile(
              leading: Icon(
                conversation.isMuted ? Icons.volume_up : Icons.volume_off,
                color: ThemeColors.primary,
              ),
              title: Text(
                conversation.isMuted ? 'Unmute' : 'Mute',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.text(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle mute/unmute
                _toggleMute(conversation);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              title: Text(
                'Delete Chat',
                style: GoogleFonts.urbanist(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(conversation);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _togglePin(ChatConversation conversation) {
    setState(() {
      final index = _conversations.indexWhere((c) => c.id == conversation.id);
      if (index != -1) {
        _conversations[index] = conversation.copyWith(isPinned: !conversation.isPinned);
        _filterConversations();
      }
    });
  }

  void _toggleMute(ChatConversation conversation) {
    setState(() {
      final index = _conversations.indexWhere((c) => c.id == conversation.id);
      if (index != -1) {
        _conversations[index] = conversation.copyWith(isMuted: !conversation.isMuted);
        _filterConversations();
      }
    });
  }

  void _showDeleteConfirmation(ChatConversation conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.cardBackground(context),
        title: Text(
          'Delete Chat',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        content: Text(
          'Are you sure you want to delete this chat with ${conversation.displayTitle}?',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.urbanist(
                color: ThemeColors.textSecondary(context),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteConversation(conversation);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.urbanist(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteConversation(ChatConversation conversation) {
    setState(() {
      _conversations.removeWhere((c) => c.id == conversation.id);
      _filterConversations();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chat deleted',
          style: GoogleFonts.urbanist(),
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _conversations.add(conversation);
              _filterConversations();
            });
          },
        ),
      ),
    );
  }

  void _showNewChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeColors.cardBackground(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Start New Chat',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.text(context),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.person_add,
                color: ThemeColors.primary,
              ),
              title: Text(
                'New Direct Message',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.text(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showNewDirectMessageDialog();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.group_add,
                color: ThemeColors.primary,
              ),
              title: Text(
                'Create Group',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.text(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCreateGroupDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNewDirectMessageDialog() {
    // For demo purposes, show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.cardBackground(context),
        title: Text(
          'New Direct Message',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        content: Text(
          'This feature will allow you to start a new conversation with someone.',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.urbanist(
                color: ThemeColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupDialog() {
    // For demo purposes, show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.cardBackground(context),
        title: Text(
          'Create Group',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        content: Text(
          'This feature will allow you to create a new group chat.',
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
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