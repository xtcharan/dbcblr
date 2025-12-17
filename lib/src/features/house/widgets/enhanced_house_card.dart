import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/house.dart';
import '../../../shared/utils/theme_colors.dart';
import '../house_detail_page.dart';

class EnhancedHouseCard extends StatelessWidget {
  final House house;
  final int rank;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EnhancedHouseCard({
    super.key,
    required this.house,
    required this.rank,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final houseColor = Color(
      int.parse(house.colorHex.substring(1), radix: 16) + 0xFF000000,
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HouseDetailPage(house: house),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeColors.cardBackground(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ThemeColors.cardBorder(context),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side - Rank and mascot
            _buildRankSection(context, houseColor),
            
            const SizedBox(width: 16),
            
            // Middle - House info
            Expanded(
              child: _buildHouseInfo(context, houseColor),
            ),
            
            const SizedBox(width: 8),
            
            // Right side - Status, arrow, and menu
            _buildStatusSection(context),
            
            // Three-dot menu
            if (onEdit != null || onDelete != null)
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: ThemeColors.iconSecondary(context),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: ThemeColors.surface(context),
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!();
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 18),
                          const SizedBox(width: 12),
                          Text(
                            'Edit House',
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (onDelete != null)
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          const SizedBox(width: 12),
                          Text(
                            'Delete House',
                            style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
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

  Widget _buildRankSection(BuildContext context, Color houseColor) {
    return Column(
      children: [
        // Rank badge
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: houseColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: houseColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$rank',
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Mascot
        Text(
          house.mascot,
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget _buildHouseInfo(BuildContext context, Color houseColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // House name
        Text(
          house.name,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        
        const SizedBox(height: 4),
        
        // Points with gradient
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    houseColor.withValues(alpha: 0.1),
                    houseColor.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: houseColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 14,
                    color: houseColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${house.points}',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: houseColor,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'pts',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: houseColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Trend indicator
        _buildTrendIndicator(context),
      ],
    );
  }

  Widget _buildTrendIndicator(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    
    switch (house.status) {
      case 'Rising':
        statusColor = Colors.green;
        statusIcon = Icons.trending_up;
        break;
      case 'Falling':
        statusColor = Colors.red;
        statusIcon = Icons.trending_down;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.trending_flat;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 12,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            house.status,
            style: GoogleFonts.urbanist(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return Column(
      children: [
        // Rank position
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ThemeColors.primaryWithOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '#$rank',
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ThemeColors.primary,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Arrow icon
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: ThemeColors.cardBorder(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: ThemeColors.iconSecondary(context),
            ),
          ),
        ),
      ],
    );
  }
}