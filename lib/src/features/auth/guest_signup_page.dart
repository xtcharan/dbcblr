import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../shared/utils/theme_colors.dart';
import '../../shared/models/user.dart';

class GuestSignupPage extends StatefulWidget {
  const GuestSignupPage({super.key});

  @override
  State<GuestSignupPage> createState() => _GuestSignupPageState();
}

class _GuestSignupPageState extends State<GuestSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _institutionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // School-specific
  final _classController = TextEditingController();
  final _sectionController = TextEditingController();

  DateTime? _selectedDob;
  String? _avatarPath;
  EducationLevel? _selectedEducationLevel;
  String? _selectedStream; // PCMB, HEBA for PU
  String? _selectedCourse; // Science, Arts, Commerce for PU; or specific course for College
  String? _selectedYear;
  String? _selectedSemester;
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final ImagePicker _picker = ImagePicker();

  final List<String> _puStreams = ['PCMB', 'HEBA', 'PCMC', 'CEBA'];
  final List<String> _puCourses = ['Science', 'Arts', 'Commerce'];
  final List<String> _puYears = ['1 PU', '2 PU'];
  final List<String> _collegeYears = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final List<String> _collegeSemesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  final List<String> _collegeCourses = ['BCA', 'B.Com', 'BA', 'BBM', 'BSW', 'BBA', 'B.Sc', 'Engineering', 'Other'];

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

    if (_selectedEducationLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your education level'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService().register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: '${_firstNameController.text} ${_lastNameController.text}',
      );

      if (mounted) {
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(2005, 1, 1),
      firstDate: DateTime(1990),
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

  @override
  Widget build(BuildContext context) {
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
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Create a Guest Account',
                    style: GoogleFonts.urbanist(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.text(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Section: Your Details
                _buildSectionTitle('Your Details'),
                const SizedBox(height: 16),
                
                // Profile Photo Upload
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
                          color: const Color(0xFF007bff).withOpacity(0.5),
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
                
                // First Name
                _buildInputField(
                  label: 'First Name *',
                  controller: _firstNameController,
                  hint: 'Enter your first name',
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                
                // Last Name
                _buildInputField(
                  label: 'Last Name *',
                  controller: _lastNameController,
                  hint: 'Enter your last name',
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
                
                // Phone Number
                _buildInputField(
                  label: 'Phone Number *',
                  controller: _phoneController,
                  hint: '+91 XXXXX XXXXX',
                  keyboardType: TextInputType.phone,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                
                const SizedBox(height: 32),
                
                // Section: Education Level
                _buildSectionTitle('Education Level'),
                const SizedBox(height: 16),
                
                // Education Level Selection
                _buildLabel('I am currently studying in *'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildEducationChip(EducationLevel.school, 'School'),
                    _buildEducationChip(EducationLevel.pu, 'PU/11th-12th'),
                    _buildEducationChip(EducationLevel.college, 'College'),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Dynamic Academic Fields
                if (_selectedEducationLevel != null) ...[
                  _buildSectionTitle('Academic Details'),
                  const SizedBox(height: 16),
                  
                  // Student ID (all levels)
                  _buildInputField(
                    label: 'Student ID *',
                    controller: _studentIdController,
                    hint: 'Your student/roll number',
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Institution Name (all levels)
                  _buildInputField(
                    label: _selectedEducationLevel == EducationLevel.school 
                        ? 'School Name *' 
                        : 'Institution Name *',
                    controller: _institutionController,
                    hint: _selectedEducationLevel == EducationLevel.school
                        ? 'Enter your school name'
                        : 'Enter your college/institution name',
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // School-specific fields
                  if (_selectedEducationLevel == EducationLevel.school) ...[
                    _buildInputField(
                      label: 'Class *',
                      controller: _classController,
                      hint: 'e.g., 10th, 9th',
                      validator: (v) => v?.isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Section (Optional)',
                      controller: _sectionController,
                      hint: 'e.g., A, B, C',
                    ),
                  ],
                  
                  // PU-specific fields
                  if (_selectedEducationLevel == EducationLevel.pu) ...[
                    _buildLabel('Stream *'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _puStreams.map((stream) {
                        final isSelected = _selectedStream == stream;
                        return ChoiceChip(
                          label: Text(stream),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedStream = selected ? stream : null);
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
                    
                    _buildLabel('Course *'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _puCourses.map((course) {
                        final isSelected = _selectedCourse == course;
                        return ChoiceChip(
                          label: Text(course),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedCourse = selected ? course : null);
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
                    
                    _buildLabel('Year *'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _puYears.map((year) {
                        final isSelected = _selectedYear == year;
                        return ChoiceChip(
                          label: Text(year),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedYear = selected ? year : null);
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
                  ],
                  
                  // College-specific fields
                  if (_selectedEducationLevel == EducationLevel.college) ...[
                    _buildLabel('Course *'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _collegeCourses.map((course) {
                        final isSelected = _selectedCourse == course;
                        return ChoiceChip(
                          label: Text(course),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedCourse = selected ? course : null);
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
                    
                    _buildLabel('Year *'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _collegeYears.map((year) {
                        final isSelected = _selectedYear == year;
                        return ChoiceChip(
                          label: Text(year),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedYear = selected ? year : null);
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
                    
                    _buildLabel('Semester *'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _collegeSemesters.map((sem) {
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
                  ],
                ],
                
                const SizedBox(height: 32),
                
                // Section: Login Info
                _buildSectionTitle('Your Login Info'),
                const SizedBox(height: 16),
                
                // Email
                _buildLabel('Email *'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.urbanist(
                    color: ThemeColors.text(context),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'your.email@example.com',
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
                    if (!v!.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Password
                _buildLabel('Password *'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.urbanist(
                    color: ThemeColors.text(context),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Create a password',
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
                    hintText: 'Confirm your password',
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
                      backgroundColor: const Color(0xFF007bff),
                      foregroundColor: Colors.white,
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
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'CREATE & VERIFY EMAIL',
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

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ThemeColors.text(context),
      ),
    );
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

  Widget _buildEducationChip(EducationLevel level, String label) {
    final isSelected = _selectedEducationLevel == level;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedEducationLevel = selected ? level : null;
          // Reset dependent fields when education level changes
          _selectedStream = null;
          _selectedCourse = null;
          _selectedYear = null;
          _selectedSemester = null;
        });
      },
      selectedColor: ThemeColors.primary,
      backgroundColor: ThemeColors.inputBackground(context),
      labelStyle: GoogleFonts.urbanist(
        color: isSelected ? Colors.black : ThemeColors.textSecondary(context),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    _studentIdController.dispose();
    _institutionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _classController.dispose();
    _sectionController.dispose();
    super.dispose();
  }
}
