import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/utils/theme_colors.dart';

class IPhoneSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const IPhoneSearchBar({
    super.key,
    this.hintText = 'Discover',
    this.onFilterTap,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: ThemeColors.inputBackground(context),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: ThemeColors.inputBorder(context),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: GoogleFonts.urbanist(
                  color: ThemeColors.text(context),
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.urbanist(
                    color: ThemeColors.textSecondary(context),
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: ThemeColors.iconSecondary(context),
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Filter Button
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ThemeColors.surface(context),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.tune,
                color: ThemeColors.primary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}