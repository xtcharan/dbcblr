import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import '../../shared/utils/theme_colors.dart';

class StudentActivationPage extends StatefulWidget {
  const StudentActivationPage({super.key});

  @override
  State<StudentActivationPage> createState() => _StudentActivationPageState();
}

class _StudentActivationPageState extends State<StudentActivationPage> {
  final _registerNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _activate() async {
    if (_registerNumberController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter register number and password'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create placeholder email for DBC student
      final placeholderEmail = '${_registerNumberController.text.toLowerCase()}@dbcblr.edu.in';
      
      // Try to login with temp credentials
      await ApiService().login(
        email: placeholderEmail,
        password: _passwordController.text,
      );

      if (mounted) {
        // Navigate to DBC onboarding to complete profile
        Navigator.pushReplacementNamed(
          context, 
          '/dbc-onboarding',
          arguments: {'registerNumber': _registerNumberController.text},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Activation failed: ${e.toString()}'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Activate Your Account',
                style: GoogleFonts.urbanist(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.text(context),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Welcome to DBC SWO! Let\'s get started.',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  color: ThemeColors.textSecondary(context),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Section Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter Your Details',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Register Number Field
              _buildLabel('Register Number'),
              const SizedBox(height: 8),
              TextField(
                controller: _registerNumberController,
                style: GoogleFonts.urbanist(
                  color: ThemeColors.text(context),
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., U19PD001',
                  hintStyle: GoogleFonts.urbanist(
                    color: ThemeColors.textSecondary(context),
                  ),
                  prefixIcon: Icon(
                    Icons.badge_outlined,
                    color: ThemeColors.icon(context),
                  ),
                  filled: true,
                  fillColor: ThemeColors.inputBackground(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              
              const SizedBox(height: 24),
              
              // Password Field
              _buildLabel('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: GoogleFonts.urbanist(
                  color: ThemeColors.text(context),
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: GoogleFonts.urbanist(
                    color: ThemeColors.textSecondary(context),
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: ThemeColors.icon(context),
                  ),
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
              ),
              
              const SizedBox(height: 40),
              
              // Proceed Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _activate,
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
                          'PROCEED',
                          style: GoogleFonts.urbanist(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Help text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: ThemeColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Use the register number and password provided by your college admin.',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: ThemeColors.text(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ThemeColors.textSecondary(context),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _registerNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
