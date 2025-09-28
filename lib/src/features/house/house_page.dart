import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/models/house.dart';
import '../../shared/models/activity.dart';
import '../../shared/utils/theme_colors.dart';
import 'widgets/animated_house_standings_chart.dart';
import 'widgets/enhanced_house_card.dart';
import 'widgets/recent_activities_section.dart';

class HousePage extends StatefulWidget {
  const HousePage({super.key});

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  final String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final houses = House.fakeList()
      ..sort((a, b) => b.points.compareTo(a.points));

    final activities = Activity.fakeFeed();
    final filteredActivities = _filter == 'All'
        ? activities
        : activities
              .where((a) => a.category.toLowerCase() == _filter.toLowerCase())
              .toList();

    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildHeader(context),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // Animated House Standings Chart
                    AnimatedHouseStandingsChart(houses: houses),
                    
                    const SizedBox(height: 16),
                    
                    // Enhanced House Cards
                    ...houses.asMap().entries.map(
                      (entry) => EnhancedHouseCard(
                        house: entry.value,
                        rank: entry.key + 1,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Recent Activities Section
                    RecentActivitiesSection(
                      activities: filteredActivities,
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Hamburger menu
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: ThemeColors.surface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.menu,
                color: ThemeColors.primary,
                size: 24,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'House System',
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Competition standings and activities',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: ThemeColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Add Points Button
          GestureDetector(
            onTap: () => _showAddPointsDialog(context),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: ThemeColors.surface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ThemeColors.cardBorder(context),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.add,
                color: ThemeColors.primary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAddPointsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _AddPointsDialog(),
    );
  }
}

class _AddPointsDialog extends StatefulWidget {
  @override
  State<_AddPointsDialog> createState() => _AddPointsDialogState();
}

class _AddPointsDialogState extends State<_AddPointsDialog> {
  final _pointsController = TextEditingController();
  final _reasonController = TextEditingController();
  String? _selectedHouse;
  String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  
  final List<String> _houses = [
    'Ruby Rhinos',
    'Sapphire Sharks', 
    'Topaz Tigers',
    'Emerald Eagles',
  ];
  
  final List<String> _categories = [
    'Sports',
    'Academic',
    'Cultural',
    'Community',
  ];
  
  @override
  void dispose() {
    _pointsController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeColors.cardBackground(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: ThemeColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'Add Points',
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeColors.text(context),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // House Selection
            DropdownButtonFormField<String>(
              initialValue: _selectedHouse,
              decoration: InputDecoration(
                labelText: 'Select House',
                labelStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeColors.cardBorder(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeColors.primary, width: 2),
                ),
              ),
              dropdownColor: ThemeColors.cardBackground(context),
              style: TextStyle(color: ThemeColors.text(context)),
              items: _houses.map((house) {
                return DropdownMenuItem(
                  value: house,
                  child: Text(house),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedHouse = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a house';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Category Selection
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Select Category',
                labelStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeColors.cardBorder(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeColors.primary, width: 2),
                ),
              ),
              dropdownColor: ThemeColors.cardBackground(context),
              style: TextStyle(color: ThemeColors.text(context)),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        color: ThemeColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Points Input
            TextFormField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: ThemeColors.text(context)),
              decoration: InputDecoration(
                labelText: 'Points to Add',
                labelStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                hintText: 'e.g., 50',
                hintStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeColors.cardBorder(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeColors.primary, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter points';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (int.parse(value) <= 0) {
                  return 'Points must be positive';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Reason Input
            TextFormField(
              controller: _reasonController,
              style: TextStyle(color: ThemeColors.text(context)),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Reason for Points',
                labelStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                hintText: 'e.g., Won inter-house football match',
                hintStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeColors.cardBorder(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeColors.primary, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a reason';
                }
                if (value.length < 10) {
                  return 'Please provide a detailed reason (min 10 characters)';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: ThemeColors.textSecondary(context)),
          ),
        ),
        ElevatedButton(
          onPressed: _addPoints,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Add Points',
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  void _addPoints() {
    if (_formKey.currentState!.validate()) {
      final points = int.parse(_pointsController.text);
      final reason = _reasonController.text;
      
      // Here you would typically save this to your database
      // For now, we'll just show a success message
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added $points points to $_selectedHouse for $_selectedCategory: $reason',
            style: GoogleFonts.urbanist(),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Icons.sports_basketball;
      case 'academic':
        return Icons.school;
      case 'cultural':
        return Icons.theater_comedy;
      case 'community':
        return Icons.people;
      default:
        return Icons.category;
    }
  }
}
