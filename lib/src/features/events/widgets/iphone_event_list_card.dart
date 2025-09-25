import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/event.dart';
import '../../../shared/utils/theme_colors.dart';

class IPhoneEventListCard extends StatelessWidget {
  final Event event;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  const IPhoneEventListCard({
    super.key,
    required this.event,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayFormatter = DateFormat('dd');
    final monthFormatter = DateFormat('MMM');
    final timeFormatter = DateFormat('HH:mm');
    
    final day = dayFormatter.format(event.startDate);
    final month = monthFormatter.format(event.startDate).toUpperCase();
    final time = timeFormatter.format(event.startDate);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeColors.cardBackground(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ThemeColors.cardBorder(context),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Small event image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ThemeColors.surface(context),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: event.eventImage != null
                    ? Image.network(
                        event.eventImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: ThemeColors.surface(context),
                              child: Icon(
                                Icons.event,
                                color: ThemeColors.iconSecondary(context),
                                size: 24,
                              ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 60,
                            height: 60,
                            color: ThemeColors.surface(context),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ThemeColors.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 60,
                        height: 60,
                          color: ThemeColors.surface(context),
                        child: Icon(
                          Icons.event,
                          color: ThemeColors.iconSecondary(context),
                          size: 24,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Event details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event title
                  Text(
                    event.title,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.text(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Time and location
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: ThemeColors.icon(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: ThemeColors.text(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: ThemeColors.icon(context),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: ThemeColors.text(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.primaryWithOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ThemeColors.primaryWithOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      event.category,
                      style: GoogleFonts.urbanist(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Date oval and heart
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Heart icon
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isFavorite 
                          ? ThemeColors.primaryWithOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : ThemeColors.icon(context),
                      size: 20,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Oval date container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.surface(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ThemeColors.cardBorder(context),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        day,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.text(context),
                        ),
                      ),
                      Text(
                        month,
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.text(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}