import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final VoidCallback? onTap;
  final bool isSelected;

  // A map of categories to their corresponding colors
  static const Map<String, Color> categoryColors = {
    'Music Festival': Colors.purple,
    'Festival Arts': Colors.orange,
    'Technology': Colors.blue,
    'Sports': Colors.green,
    'Academic': Colors.red,
    'Workshop': Colors.amber,
  };

  const CategoryChip({
    super.key,
    required this.category,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get the color for this category, or use a default color if not found
    final Color chipColor = categoryColors[category] ?? Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor
              : chipColor.withOpacityValue(0.2), // 0.2 opacity
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: chipColor.withOpacityValue(0.5), // 0.5 opacity
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Optional: Add an icon based on category
            _getCategoryIcon(category),
            const SizedBox(width: 6),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : chipColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get an icon for each category
  Widget _getCategoryIcon(String category) {
    IconData iconData;

    switch (category) {
      case 'Music Festival':
        iconData = Icons.music_note;
        break;
      case 'Festival Arts':
        iconData = Icons.festival;
        break;
      case 'Technology':
        iconData = Icons.computer;
        break;
      case 'Sports':
        iconData = Icons.sports_basketball;
        break;
      case 'Academic':
        iconData = Icons.school;
        break;
      case 'Workshop':
        iconData = Icons.build;
        break;
      default:
        iconData = Icons.category;
        break;
    }

    return Icon(
      iconData,
      size: 14,
      color: isSelected
          ? Colors.white
          : categoryColors[category] ?? Colors.grey,
    );
  }
}
