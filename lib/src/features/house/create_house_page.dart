import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../shared/utils/theme_colors.dart';
import '../../shared/models/house.dart';
import '../../services/api_service.dart';

class CreateHousePage extends StatefulWidget {
  final House? house; // Optional: if provided, page is in edit mode
  
  const CreateHousePage({super.key, this.house});

  @override
  State<CreateHousePage> createState() => _CreateHousePageState();
}

class _CreateHousePageState extends State<CreateHousePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedColor = '#E53E3E'; // Default red
  String? _logoUrl;
  File? _logoFile;
  bool _isLoading = false;
  bool _isLoadingRoles = false;
  
  // Dynamic roles list
  final List<Map<String, TextEditingController>> _roles = [];
  
  bool get _isEditMode => widget.house != null;
  
  // Predefined colors for houses
  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Ruby Red', 'color': '#E53E3E'},
    {'name': 'Sapphire Blue', 'color': '#3182CE'},
    {'name': 'Topaz Orange', 'color': '#DD6B20'},
    {'name': 'Emerald Green', 'color': '#38A169'},
    {'name': 'Amethyst Purple', 'color': '#805AD5'},
    {'name': 'Diamond White', 'color': '#718096'},
    {'name': 'Onyx Black', 'color': '#2D3748'},
    {'name': 'Gold', 'color': '#D69E2E'},
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _initializeEditMode();
    }
  }
  
  void _initializeEditMode() {
    final house = widget.house!;
    _nameController.text = house.name;
    _descriptionController.text = house.description ?? '';
    _selectedColor = house.colorHex;
    _logoUrl = house.logoUrl;
    
    // Load existing roles
    _loadHouseRoles();
  }
  
  Future<void> _loadHouseRoles() async {
    setState(() {
      _isLoadingRoles = true;
    });
    
    try {
      final houseData = await _apiService.getHouse(widget.house!.id);
      final roles = houseData['roles'] as List<dynamic>? ?? [];
      
      setState(() {
        _roles.clear();
        for (var role in roles) {
          _roles.add({
            'name': TextEditingController(text: role['member_name']),
            'title': TextEditingController(text: role['role_title']),
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load roles: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoadingRoles = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (var role in _roles) {
      role['name']?.dispose();
      role['title']?.dispose();
    }
    super.dispose();
  }

  void _addRole() {
    setState(() {
      _roles.add({
        'name': TextEditingController(),
        'title': TextEditingController(),
      });
    });
  }

  void _removeRole(int index) {
    setState(() {
      _roles[index]['name']?.dispose();
      _roles[index]['title']?.dispose();
      _roles.removeAt(index);
    });
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _logoFile = File(image.path);
      });
      
      // Upload to server
      try {
        final url = await _apiService.uploadImage(_logoFile!);
        setState(() {
          _logoUrl = url;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload logo: $e')),
          );
        }
      }
    }
  }

  Future<void> _saveHouse() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isEditMode) {
        // Update existing house
        await _apiService.updateHouse(
          id: widget.house!.id,
          name: _nameController.text.trim(),
          color: _selectedColor,
          description: _descriptionController.text.trim().isNotEmpty 
              ? _descriptionController.text.trim() 
              : null,
          logoUrl: _logoUrl,
        );
        
        // TODO: Update roles - need to handle role updates
        // For now, just keeping existing roles as-is
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('House updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        // Create new house
        final houseData = await _apiService.createHouse(
          name: _nameController.text.trim(),
          color: _selectedColor,
          description: _descriptionController.text.trim().isNotEmpty 
              ? _descriptionController.text.trim() 
              : null,
          logoUrl: _logoUrl,
        );
        
        final houseId = houseData['id'];
        
        // Add roles
        for (int i = 0; i < _roles.length; i++) {
          final memberName = _roles[i]['name']!.text.trim();
          final roleTitle = _roles[i]['title']!.text.trim();
          
          if (memberName.isNotEmpty && roleTitle.isNotEmpty) {
            await _apiService.addHouseRole(
              houseId: houseId,
              memberName: memberName,
              roleTitle: roleTitle,
              displayOrder: i,
            );
          }
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('House created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? 'Failed to update house: $e' : 'Failed to create house: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.surface(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: ThemeColors.text(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditMode ? 'Edit House' : 'Create House',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            color: ThemeColors.text(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _isLoading ? null : _saveHouse,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isEditMode ? 'Update' : 'Create',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.primary,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Upload Section
              _buildSectionTitle('House Logo'),
              const SizedBox(height: 12),
              _buildLogoUpload(),
              
              const SizedBox(height: 24),
              
              // House Name
              _buildSectionTitle('House Name *'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('e.g., Ruby Rhinos'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a house name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // House Color
              _buildSectionTitle('House Color *'),
              const SizedBox(height: 12),
              _buildColorPicker(),
              
              const SizedBox(height: 24),
              
              // Description
              _buildSectionTitle('Description'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Describe the house spirit and values...'),
                maxLines: 3,
              ),
              
              const SizedBox(height: 32),
              
              // Roles Section
              _buildRolesSection(),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ThemeColors.text(context),
      ),
    );
  }

  Widget _buildLogoUpload() {
    return GestureDetector(
      onTap: _pickLogo,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: ThemeColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ThemeColors.cardBorder(context),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: _logoFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  _logoFile!,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 40,
                    color: ThemeColors.textSecondary(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Logo',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: ThemeColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _colorOptions.map((option) {
        final isSelected = _selectedColor == option['color'];
        final color = Color(
          int.parse(option['color'].substring(1), radix: 16) + 0xFF000000,
        );
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = option['color'];
            });
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRolesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('House Roles'),
            TextButton.icon(
              onPressed: _addRole,
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: Text(
                'Add Role',
                style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Add members with their roles (e.g., House Captain)',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            color: ThemeColors.textSecondary(context),
          ),
        ),
        const SizedBox(height: 16),
        
        if (_roles.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ThemeColors.surface(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeColors.cardBorder(context)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 48,
                  color: ThemeColors.textSecondary(context),
                ),
                const SizedBox(height: 12),
                Text(
                  'No roles added yet',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: ThemeColors.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _addRole,
                  child: Text(
                    'Add your first role',
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ...List.generate(_roles.length, (index) => _buildRoleCard(index)),
      ],
    );
  }

  Widget _buildRoleCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.cardBorder(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(
                    int.parse(_selectedColor.substring(1), radix: 16) + 0xFF000000,
                  ).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.bold,
                      color: Color(
                        int.parse(_selectedColor.substring(1), radix: 16) + 0xFF000000,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _removeRole(index),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _roles[index]['name'],
            decoration: _inputDecoration('Member Name'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _roles[index]['title'],
            decoration: _inputDecoration('Role Title (e.g., House Captain)'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.urbanist(
        color: ThemeColors.textSecondary(context),
      ),
      filled: true,
      fillColor: ThemeColors.surface(context),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ThemeColors.cardBorder(context)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ThemeColors.cardBorder(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ThemeColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
