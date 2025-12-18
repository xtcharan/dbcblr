import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import '../../shared/utils/theme_colors.dart';

class GuestSignupPage extends StatefulWidget {
  const GuestSignupPage({super.key});

  @override
  State<GuestSignupPage> createState() => _GuestSignupPageState();
}

class _GuestSignupPageState extends State<GuestSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _collegeNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
                      'lib/src/features/auth/logo.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
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
                
                // College Name
                _buildInputField(
                  label: 'College Name',
                  controller: _collegeNameController,
                  hint: 'Your college or organization',
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
    _collegeNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
