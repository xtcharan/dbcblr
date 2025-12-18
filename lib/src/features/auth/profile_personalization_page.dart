import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/utils/theme_colors.dart';

class ProfilePersonalizationPage extends StatefulWidget {
  const ProfilePersonalizationPage({super.key});

  @override
  State<ProfilePersonalizationPage> createState() => _ProfilePersonalizationPageState();
}

class _ProfilePersonalizationPageState extends State<ProfilePersonalizationPage> {
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  final Set<String> _selectedInterests = {};

  final List<String> _interests = [
    'Sports', 'Tech', 'Music', 'Arts', 'Dance', 'Debating', 
    'Gaming', 'Cultural', 'Coding', 'Literature', 'Photography', 'Drama'
  ];

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Save profile to backend
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _skip() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              
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
                'You\'re In! 🎉',
                style: GoogleFonts.urbanist(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.text(context),
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Let\'s personalize your profile',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  color: ThemeColors.textSecondary(context),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Avatar Placeholder
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: ThemeColors.inputBackground(context),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ThemeColors.primary,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: ThemeColors.textSecondary(context),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: ThemeColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Upload Avatar',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.primary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Username
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: _usernameController,
                style: GoogleFonts.urbanist(
                  color: ThemeColors.text(context),
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., JohnDoe25',
                  hintStyle: GoogleFonts.urbanist(
                    color: ThemeColors.textSecondary(context),
                  ),
                  prefixIcon: Icon(Icons.alternate_email, color: ThemeColors.icon(context)),
                  filled: true,
                  fillColor: ThemeColors.inputBackground(context),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Interests
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What are you interested in?',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.text(context),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _interests.map((interest) {
                  final isSelected = _selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
                    selectedColor: const Color(0xFF007bff),
                    backgroundColor: ThemeColors.inputBackground(context),
                    checkmarkColor: Colors.white,
                    labelStyle: GoogleFonts.urbanist(
                      color: isSelected ? Colors.white : ThemeColors.textSecondary(context),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF007bff) : Colors.transparent,
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 48),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
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
                          'SAVE & ENTER',
                          style: GoogleFonts.urbanist(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Skip Button
              TextButton(
                onPressed: _skip,
                child: Text(
                  'Skip for now',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: ThemeColors.textSecondary(context),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
