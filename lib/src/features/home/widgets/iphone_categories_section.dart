import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IPhoneCategoriesSection extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String) onCategoryTap;

  const IPhoneCategoriesSection({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategoryTap,
  });

  // Mock category images - replace with your actual category images
  String _getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'music':
        return 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=150&h=150&fit=crop&crop=face';
      case 'festival':
        return 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=150&h=150&fit=crop&crop=face';
      case 'tech':
        return 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=150&h=150&fit=crop&crop=face';
      case 'sports':
        return 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150&h=150&fit=crop&crop=face';
      case 'art':
        return 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=150&h=150&fit=crop&crop=face';
      case 'food':
        return 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=150&h=150&fit=crop&crop=face';
      case 'business':
        return 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face';
      case 'education':
        return 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=150&h=150&fit=crop&crop=face';
      default:
        return 'https://images.unsplash.com/photo-1566492031773-4f4e44671d66?w=150&h=150&fit=crop&crop=face';
    }
  }

  // Fallback icons for categories when images fail to load
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'music':
        return Icons.music_note;
      case 'festival':
        return Icons.festival;
      case 'tech':
        return Icons.computer;
      case 'sports':
        return Icons.sports_soccer;
      case 'art':
        return Icons.palette;
      case 'food':
        return Icons.restaurant;
      case 'business':
        return Icons.business;
      case 'education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Categories',
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Categories List
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              final categoryImage = _getCategoryImage(category);
              
              return GestureDetector(
                onTap: () => onCategoryTap(category),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      // Round Profile Picture
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFFf8ce82)
                                : const Color(0xFF2A2A2A),
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: const Color(0xFFf8ce82).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ] : null,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            categoryImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A1A1A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.image,
                                  color: Color(0xFF404040),
                                  size: 24,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A1A1A),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getCategoryIcon(category),
                                  color: isSelected 
                                      ? const Color(0xFFf8ce82)
                                      : const Color(0xFF404040),
                                  size: 24,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Category Name
                      Text(
                        category,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? const Color(0xFFf8ce82)
                              : const Color(0xFF404040),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}