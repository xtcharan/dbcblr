import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/event.dart';
import '../../../shared/widgets/network_avatar.dart';
import '../../../shared/utils/font_utils.dart';
import '../../../shared/utils/theme_colors.dart';

class IPhoneEventCard extends StatelessWidget {
  final Event event;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onJoinPressed;

  const IPhoneEventCard({
    super.key,
    required this.event,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onJoinPressed,
  });

  @override
  Widget build(BuildContext context) {
    final dayFormatter = DateFormat('dd');
    final monthFormatter = DateFormat('MMM');
    final day = dayFormatter.format(event.startDate);
    final month = monthFormatter.format(event.startDate).toUpperCase();

    // Mock joined users data
    final joinedUsers = [
      'https://i.pravatar.cc/150?img=1',
      'https://i.pravatar.cc/150?img=2',
      'https://i.pravatar.cc/150?img=3',
      'https://i.pravatar.cc/150?img=4',
    ];
    final totalJoined = 24;

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: ThemeColors.cardBackground(context),
          border: Border.all(
            color: ThemeColors.cardBorder(context),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: Theme.of(context).brightness == Brightness.light ? 8 : 20,
              offset: Offset(0, Theme.of(context).brightness == Brightness.light ? 4 : 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Heart and Date
            Stack(
              children: [
                // Event Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: event.eventImage != null
                        ? Image.network(
                            event.eventImage!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey[800]!,
                                      Colors.grey[900]!,
                                    ],
                                  ),
                                ),
                                child: Center(
                                child: CircularProgressIndicator(
                                  color: ThemeColors.primary,
                                ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: ThemeColors.surface(context),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.event,
                                    size: 50,
                                    color: ThemeColors.iconSecondary(context),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: ThemeColors.surface(context),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.event,
                                size: 50,
                                color: ThemeColors.iconSecondary(context),
                              ),
                            ),
                          ),
                  ),
                ),
                
                // Gradient Overlay
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Heart Icon
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),

                // Date Circle
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: ThemeColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ThemeColors.primaryWithOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day,
                          style: FontUtils.urbanistSafe(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            context: context,
                          ),
                        ),
                        Text(
                          month,
                          style: FontUtils.urbanistSafe(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    event.title,
                    style: FontUtils.urbanistSafe(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.text(context),
                      context: context,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color(0xFF404040),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location,
                          style: FontUtils.urbanistSafe(
                            fontSize: 14,
                            color: ThemeColors.textSecondary(context),
                            context: context,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Joined Users and Join Button
                  Row(
                    children: [
                      // Joined Users Avatar Stack
                      SizedBox(
                        width: 80,
                        height: 32,
                        child: Stack(
                          children: [
                            ...joinedUsers.take(3).indexed.map((entry) {
                              int index = entry.$1;
                              String avatarUrl = entry.$2;
                              
                              return Positioned(
                                left: index * 18.0,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: NetworkAvatar(
                                    imageUrl: avatarUrl,
                                    radius: 14,
                                  ),
                                ),
                              );
                            }),
                            
                            // More count circle
                            if (totalJoined > 3)
                              Positioned(
                                left: 54,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF404040),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${totalJoined - 3}',
                                      style: FontUtils.urbanistSafe(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        context: context,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Text(
                        '$totalJoined joined',
                        style: FontUtils.urbanistSafe(
                          fontSize: 12,
                          color: ThemeColors.textSecondary(context),
                          context: context,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Join Button
                      GestureDetector(
                        onTap: onJoinPressed,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: ThemeColors.primaryWithOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'Join Now',
                            style: FontUtils.urbanistSafe(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              context: context,
                            ),
                          ),
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
}