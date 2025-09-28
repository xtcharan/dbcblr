import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/utils/theme_colors.dart';
import '../models/chat_conversation.dart';

class ConversationItem extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ConversationItem({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ThemeColors.cardBorder(context),
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: conversation.displayAvatar.isNotEmpty
                        ? Image.network(
                            conversation.displayAvatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultAvatar(context),
                          )
                        : _buildDefaultAvatar(context),
                  ),
                ),
                // Online indicator
                if (conversation.isOnline && conversation.type == ConversationType.direct)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ThemeColors.background(context),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                // Group indicator
                if (conversation.type == ConversationType.group)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: ThemeColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ThemeColors.background(context),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.group,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and timestamp row
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // Pinned indicator
                            if (conversation.isPinned)
                              Container(
                                margin: const EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.push_pin,
                                  size: 14,
                                  color: ThemeColors.primary,
                                ),
                              ),
                            // Title
                            Flexible(
                              child: Text(
                                conversation.displayTitle,
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: conversation.unreadCount > 0 
                                      ? FontWeight.w600 
                                      : FontWeight.w500,
                                  color: ThemeColors.text(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Muted indicator
                            if (conversation.isMuted)
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.volume_off,
                                  size: 14,
                                  color: ThemeColors.textSecondary(context),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Timestamp
                      Text(
                        conversation.lastActivityTime,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: conversation.unreadCount > 0
                              ? ThemeColors.primary
                              : ThemeColors.textSecondary(context),
                          fontWeight: conversation.unreadCount > 0 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Last message and unread count row
                  Row(
                    children: [
                      // Last message
                      Expanded(
                        child: Text(
                          conversation.lastMessagePreview,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: conversation.unreadCount > 0
                                ? ThemeColors.text(context)
                                : ThemeColors.textSecondary(context),
                            fontWeight: conversation.unreadCount > 0 
                                ? FontWeight.w500 
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Unread count badge
                      if (conversation.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            conversation.unreadCount > 99 
                                ? '99+' 
                                : conversation.unreadCount.toString(),
                            style: GoogleFonts.urbanist(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: ThemeColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        conversation.type == ConversationType.group 
            ? Icons.group 
            : Icons.person,
        size: 28,
        color: ThemeColors.primary,
      ),
    );
  }
}