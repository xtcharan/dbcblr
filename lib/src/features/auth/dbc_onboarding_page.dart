import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../shared/utils/theme_colors.dart';

class DBCOnboardingPage extends StatefulWidget {
  const DBCOnboardingPage({super.key});

  @override
  State<DBCOnboardingPage> createState() => _DBCOnboardingPageState();
}

class _DBCOnboardingPageState extends State<DBCOnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedYear;
  String? _selectedSemester;
  DateTime? _selectedDob;
  String? _avatarPath;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final ImagePicker _picker = ImagePicker();

  final List<String> _departments = [
    'BCA', 'B.COM', 'BA', 'BBM', 'BSW', 'BBA', 'B.Sc'
  ];

  final List<String> _years = ['1st Year', '2nd Year', '3rd Year'];
  final List<String> _semesters = ['1', '2', '3', '4', '5', '6'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate email domain
    if (!_emailController.text.endsWith('@dbcblr.edu.in')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please use your @dbcblr.edu.in email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Register user
      await ApiService().register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: '${_firstNameController.text} ${_lastNameController.text}',
        department: _selectedDepartment,
        year: int.tryParse(_selectedYear?.replaceAll(RegExp(r'[^0-9]'), '') ?? ''),
      );

      if (mounted) {
        // Navigate to OTP verification
        Navigator.pushReplacementNamed(
          context,
          '/otp-verification',
          arguments: {
            'email': _emailController.text.trim(),
            'isNewUser': true,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final registerNumber = args?['registerNumber'] ?? 'Your Reg No';

    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.text(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Welcome! Let\'s get you set up.',
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.text(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Complete your profile to continue',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: ThemeColors.textSecondary(context),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Register Number Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: ThemeColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.badge, color: ThemeColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Register Number: $registerNumber',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.text(context),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Section: Your Details
                Text(
                  'Your Details',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
                const SizedBox(height: 16),
                
                // First Name
                _buildInputField(
                  label: 'First Name *',
                  controller: _firstNameController,
                  hint: 'Enter first name',
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                
                const SizedBox(height: 16),
                
                // Last Name
                _buildInputField(
                  label: 'Last Name *',
                  controller: _lastNameController,
                  hint: 'Enter last name',
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                
                const SizedBox(height: 16),
                
                // Date of Birth
                _buildLabel('Date of Birth *'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: ThemeColors.inputBackground(context),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: ThemeColors.icon(context)),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDob != null
                              ? DateFormat('dd MMM yyyy').format(_selectedDob!)
                              : 'Select your date of birth',
                          style: GoogleFonts.urbanist(
                            color: _selectedDob != null
                                ? ThemeColors.text(context)
                                : ThemeColors.textSecondary(context),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Profile Photo Upload
                _buildLabel('Profile Photo *'),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: ThemeColors.inputBackground(context),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ThemeColors.primary.withOpacity(0.5),
                          width: 2,
                        ),
                        image: _avatarPath != null
                            ? DecorationImage(
                                image: FileImage(File(_avatarPath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _avatarPath == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                  color: ThemeColors.icon(context),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Upload Photo',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: ThemeColors.textSecondary(context),
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Use a real photo, no drawings or caricatures',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: ThemeColors.textSecondary(context),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Last Name
                _buildInputField(
                  label: 'Last Name *',
                  controller: _lastNameController,
                  hint: 'Enter last name',
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                
                const SizedBox(height: 16),
                
                // Department
                _buildLabel('Department'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _departments.map((dept) {
                    final isSelected = _selectedDepartment == dept;
                    return ChoiceChip(
                      label: Text(dept),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedDepartment = selected ? dept : null);
                      },
                      selectedColor: ThemeColors.primary,
                      backgroundColor: ThemeColors.inputBackground(context),
                      labelStyle: GoogleFonts.urbanist(
                        color: isSelected ? Colors.black : ThemeColors.textSecondary(context),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Year
                _buildLabel('Year'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _years.map((year) {
                    final isSelected = _selectedYear == year;
                    return ChoiceChip(
                      label: Text(year),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedYear = selected ? year : null);
                      },
                      selectedColor: const Color(0xFF007bff),
                      backgroundColor: ThemeColors.inputBackground(context),
                      labelStyle: GoogleFonts.urbanist(
                        color: isSelected ? Colors.white : ThemeColors.textSecondary(context),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Semester
                _buildLabel('Semester'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _semesters.map((sem) {
                    final isSelected = _selectedSemester == sem;
                    return ChoiceChip(
                      label: Text('Sem $sem'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedSemester = selected ? sem : null);
                      },
                      selectedColor: const Color(0xFF28a745),
                      backgroundColor: ThemeColors.inputBackground(context),
                      labelStyle: GoogleFonts.urbanist(
                        color: isSelected ? Colors.white : ThemeColors.textSecondary(context),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Phone Number
                _buildInputField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  hint: '+91 XXXXX XXXXX',
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 32),
                
                // Section: Your Login Info
                Text(
                  'Your Login Info',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
                const SizedBox(height: 16),
                
                // College Email
                _buildLabel('College Email *'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.urbanist(
                    color: ThemeColors.text(context),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'yourname@dbcblr.edu.in',
                    hintStyle: GoogleFonts.urbanist(
                      color: ThemeColors.textSecondary(context),
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: ThemeColors.icon(context)),
                    filled: true,
                    fillColor: ThemeColors.inputBackground(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) {
                    if (v?.isEmpty == true) return 'Required';
                    if (!v!.endsWith('@dbcblr.edu.in')) return 'Must be @dbcblr.edu.in email';
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // New Password
                _buildLabel('New Password *'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.urbanist(
                    color: ThemeColors.text(context),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
                    hintStyle: GoogleFonts.urbanist(
                      color: ThemeColors.textSecondary(context),
                    ),
                    prefixIcon: Icon(Icons.lock_outlined, color: ThemeColors.icon(context)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: ThemeColors.icon(context),
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: ThemeColors.inputBackground(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) {
                    if (v?.isEmpty == true) return 'Required';
                    if (v!.length < 8) return 'Must be at least 8 characters';
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Confirm Password
                _buildLabel('Confirm Password *'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: GoogleFonts.urbanist(
                    color: ThemeColors.text(context),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Confirm new password',
                    hintStyle: GoogleFonts.urbanist(
                      color: ThemeColors.textSecondary(context),
                    ),
                    prefixIcon: Icon(Icons.lock_outlined, color: ThemeColors.icon(context)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: ThemeColors.icon(context),
                      ),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    filled: true,
                    fillColor: ThemeColors.inputBackground(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                
                const SizedBox(height: 40),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'FINISH & VERIFY EMAIL',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      helpText: 'Select your date of birth',
    );
    if (picked != null && picked != _selectedDob) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _avatarPath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ThemeColors.textSecondary(context),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.urbanist(
            color: ThemeColors.text(context),
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.urbanist(
              color: ThemeColors.textSecondary(context),
            ),
            filled: true,
            fillColor: ThemeColors.inputBackground(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
