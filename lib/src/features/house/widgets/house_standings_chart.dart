import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/house.dart';
import '../../../shared/utils/theme_colors.dart';

class HouseStandingsChart extends StatelessWidget {
  final List<House> houses;

  const HouseStandingsChart({
    super.key,
    required this.houses,
  });

  @override
  Widget build(BuildContext context) {
    // Sort houses by points in descending order
    final sortedHouses = List<House>.from(houses)
      ..sort((a, b) => b.points.compareTo(a.points));
    
    final maxPoints = sortedHouses.first.points;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: ThemeColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'House Standings',
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.text(context),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeColors.primaryWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${sortedHouses.length} Houses',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.primary,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Chart
          ...sortedHouses.asMap().entries.map((entry) {
            final index = entry.key;
            final house = entry.value;
            final percentage = house.points / maxPoints;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildBarItem(
                context,
                house,
                index + 1,
                percentage,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBarItem(
    BuildContext context,
    House house,
    int rank,
    double percentage,
  ) {
    final houseColor = Color(
      int.parse(house.colorHex.substring(1), radix: 16) + 0xFF000000,
    );

    return Column(
      children: [
        // House info row
        Row(
          children: [
            // Rank badge
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: houseColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // House mascot and name
            Text(
              house.mascot,
              style: const TextStyle(fontSize: 20),
            ),
            
            const SizedBox(width: 8),
            
            Expanded(
              child: Text(
                house.name,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.text(context),
                ),
              ),
            ),
            
            // Points
            Text(
              '${house.points}',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: houseColor,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Progress bar
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ThemeColors.cardBorder(context),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: houseColor,
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    houseColor,
                    houseColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}