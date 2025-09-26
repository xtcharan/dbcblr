import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/models/house.dart';
import '../../../shared/utils/theme_colors.dart';

class AnimatedHouseStandingsChart extends StatefulWidget {
  final List<House> houses;

  const AnimatedHouseStandingsChart({
    super.key,
    required this.houses,
  });

  @override
  State<AnimatedHouseStandingsChart> createState() => _AnimatedHouseStandingsChartState();
}

class _AnimatedHouseStandingsChartState extends State<AnimatedHouseStandingsChart>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late List<AnimationController> _barAnimationControllers;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    // Individual bar animation controllers
    _barAnimationControllers = List.generate(
      widget.houses.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 300)), // Much slower animation
        vsync: this,
      ),
    );

    _barAnimations = _barAnimationControllers
        .map((controller) => CurvedAnimation(
              parent: controller,
              curve: Curves.elasticOut,
            ))
        .toList();

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    _animationController.forward();
    
    // Stagger bar animations
    for (int i = 0; i < _barAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 250), () {
        if (mounted) {
          _barAnimationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _barAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sort houses by points in descending order
    final sortedHouses = List<House>.from(widget.houses)
      ..sort((a, b) => b.points.compareTo(a.points));
    
    final maxPoints = sortedHouses.first.points;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Transform.scale(
                scale: _animation.value,
                child: Row(
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
              ),
              
              const SizedBox(height: 30),
              
              // Vertical Bar Chart
              SizedBox(
                height: 275,
                width: double.infinity,
                child: sortedHouses.length <= 4
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: sortedHouses.asMap().entries.map((entry) {
                          final index = entry.key;
                          final house = entry.value;
                          final percentage = house.points / maxPoints;
                          
                          return Flexible(
                            child: _buildAnimatedBar(
                              context,
                              house,
                              index + 1,
                              percentage,
                              index,
                              maxPoints,
                            ),
                          );
                        }).toList(),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: sortedHouses.asMap().entries.map((entry) {
                            final index = entry.key;
                            final house = entry.value;
                            final percentage = house.points / maxPoints;
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: _buildAnimatedBar(
                                context,
                                house,
                                index + 1,
                                percentage,
                                index,
                                maxPoints,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBar(
    BuildContext context,
    House house,
    int rank,
    double percentage,
    int index,
    int maxPoints,
  ) {
    final houseColor = Color(
      int.parse(house.colorHex.substring(1), radix: 16) + 0xFF000000,
    );

    return AnimatedBuilder(
      animation: _barAnimations[index],
      builder: (context, child) {
        return SizedBox(
          width: 90,
          height: 275,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            // Points label above bar (no animation)
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              constraints: const BoxConstraints(maxWidth: 80),
              decoration: BoxDecoration(
                color: houseColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: houseColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                '${house.points}',
                style: GoogleFonts.urbanist(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: houseColor,
                ),
              ),
            ),
            
            // Animated Bar
            Container(
              width: 50,
              height: _calculateBarHeight(house.points, maxPoints) * _barAnimations[index].value,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    houseColor,
                    houseColor.withValues(alpha: 0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: houseColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Gradient overlay for depth
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                  
                  // Rank badge
                  if (_barAnimations[index].value > 0.8)
                    Positioned(
                      top: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: houseColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$rank',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: houseColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 2),
            
            // House name - Fixed height container for uniformity (no animation)
            Container(
              width: 85,
              height: 28, // Fixed height for uniformity
              alignment: Alignment.topCenter,
              child: Text(
                _formatHouseName(house.name),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.urbanist(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.text(context),
                  height: 1.1,
                ),
              ),
            ),
            ],
          ),
        );
      },
    );
  }

  double _calculateBarHeight(int points, int maxPoints) {
    // Base height for the chart area (reduced to account for name container)
    const double maxHeight = 170.0;
    const double minHeight = 15.0;
    
    if (maxPoints == 0) return minHeight;
    
    // Calculate true proportional height (first place = full height, others proportional)
    double proportionalHeight = (points / maxPoints) * maxHeight;
    
    // Ensure minimum visibility but keep true proportions
    return proportionalHeight < minHeight ? minHeight : proportionalHeight;
  }
  
  String _formatHouseName(String name) {
    // Split long house names into two lines for uniformity
    final words = name.split(' ');
    if (words.length == 1) {
      // Single word - try to break it in the middle if it's long
      if (name.length > 8) {
        final mid = (name.length / 2).round();
        return '${name.substring(0, mid)}\n${name.substring(mid)}';
      }
      return '$name\n'; // Add empty line for consistency
    } else if (words.length == 2) {
      return '${words[0]}\n${words[1]}';
    } else {
      // More than 2 words - put half on each line
      final mid = (words.length / 2).ceil();
      final firstLine = words.take(mid).join(' ');
      final secondLine = words.skip(mid).join(' ');
      return '$firstLine\n$secondLine';
    }
  }
}