import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/models/house.dart';
import '../../shared/utils/theme_colors.dart';
import '../../services/api_service.dart';
import 'widgets/animated_house_standings_chart.dart';
import 'widgets/enhanced_house_card.dart';
import 'create_house_page.dart';

class HousePage extends StatefulWidget {
  const HousePage({super.key});

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  final ApiService _apiService = ApiService();
  
  List<House> _houses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHouses();
  }

  Future<void> _loadHouses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final housesData = await _apiService.getHouses();
      setState(() {
        _houses = housesData.map((json) => House.fromJson(json)).toList()
          ..sort((a, b) => b.points.compareTo(a.points));
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to fake data if API fails
      setState(() {
        _houses = House.fakeList()..sort((a, b) => b.points.compareTo(a.points));
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildHeader(context),
            
            // Scrollable Content
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadHouses,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          
                          // Animated House Standings Chart
                          AnimatedHouseStandingsChart(houses: _houses),
                          
                          const SizedBox(height: 16),
                          
                          // Enhanced House Cards with edit/delete
                          ..._houses.asMap().entries.map(
                            (entry) => EnhancedHouseCard(
                              house: entry.value,
                              rank: entry.key + 1,
                              onEdit: () => _editHouse(entry.value),
                              onDelete: () => _deleteHouse(entry.value),
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editHouse(House house) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateHousePage(house: house),
      ),
    );
    if (result == true) {
      _loadHouses(); // Refresh the list
    }
  }

  Future<void> _deleteHouse(House house) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${house.name}?'),
        content: const Text('This action cannot be undone. All house data including roles, announcements, and events will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _apiService.deleteHouse(house.id);
        _loadHouses();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${house.name} deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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
          
          // Add House Button (Admin)
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateHousePage(),
                ),
              );
              if (result == true) {
                _loadHouses(); // Refresh the list
              }
            },
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
          
          const SizedBox(width: 8),
          
          // Add Points Button (Admin)
          if (_houses.isNotEmpty)
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
                  Icons.emoji_events,
                  color: ThemeColors.primary,
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  void _showAddPointsDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => _AddPointsDialog(houses: _houses),
    );
    
    if (result == true) {
      _loadHouses(); // Refresh house list to show updated points
    }
  }
}

class _AddPointsDialog extends StatefulWidget {
  final List<House> houses;

  const _AddPointsDialog({required this.houses});

  @override
  State<_AddPointsDialog> createState() => _AddPointsDialogState();
}

class _AddPointsDialogState extends State<_AddPointsDialog> {
  final _pointsController = TextEditingController();
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  
  House? _selectedHouse;
  bool _isLoading = false;
  
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
          const Icon(
            Icons.emoji_events,
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
      content: SizedBox(
        width: 300,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // House Selection Dropdown
                DropdownButtonFormField<House>(
                  value: _selectedHouse,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Select House',
                    labelStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ThemeColors.cardBorder(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ThemeColors.primary, width: 2),
                    ),
                  ),
                dropdownColor: ThemeColors.cardBackground(context),
                style: TextStyle(color: ThemeColors.text(context)),
                items: widget.houses.map((house) {
                  final houseColor = Color(
                    int.parse(house.colorHex.substring(1), radix: 16) + 0xFF000000,
                  );
                  return DropdownMenuItem<House>(
                    value: house,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: houseColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('${house.name} (${house.points} pts)'),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHouse = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a house';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Points Input
              TextFormField(
                controller: _pointsController,
                keyboardType: const TextInputType.numberWithOptions(signed: true),
                style: TextStyle(color: ThemeColors.text(context)),
                decoration: InputDecoration(
                  labelText: 'Points',
                  labelStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                  hintText: 'e.g., 50 or -10',
                  hintStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                  helperText: 'Use negative for deduction',
                  helperStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ThemeColors.cardBorder(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ThemeColors.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter points';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(value) == 0) {
                    return 'Points cannot be zero';
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
                  labelText: 'Reason',
                  labelStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                  hintText: 'e.g., Won inter-house football match',
                  hintStyle: TextStyle(color: ThemeColors.textSecondary(context)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ThemeColors.cardBorder(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ThemeColors.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: TextStyle(color: ThemeColors.textSecondary(context)),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _addPoints,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(
                  'Add Points',
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
  
  Future<void> _addPoints() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final points = int.parse(_pointsController.text);
      final reason = _reasonController.text;
      
      await _apiService.addHousePoints(
        houseId: _selectedHouse!.id,
        points: points,
        reason: reason,
      );
      
      if (mounted) {
        Navigator.of(context).pop(true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              points > 0
                  ? 'Added $points points to ${_selectedHouse!.name}'
                  : 'Deducted ${points.abs()} points from ${_selectedHouse!.name}',
              style: GoogleFonts.urbanist(),
            ),
            backgroundColor: points > 0 ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add points: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
