import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/utils/theme_colors.dart';

class SignupChoicePage extends StatelessWidget {
  const SignupChoicePage({super.key});

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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'lib/src/features/auth/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'Join the DBC Community',
                style: GoogleFonts.urbanist(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.text(context),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'How would you like to sign up?',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  color: ThemeColors.textSecondary(context),
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // DBC Student Button
              _buildChoiceButton(
                context: context,
                icon: Icons.school_rounded,
                title: 'I am a DBC Student',
                subtitle: 'Use your @dbcblr.edu.in email',
                color: const Color(0xFF007bff),
                onTap: () {
                  Navigator.pushNamed(context, '/student-activation');
                },
              ),
              
              const SizedBox(height: 20),
              
              // Guest Button
              _buildChoiceButton(
                context: context,
                icon: Icons.person_outline_rounded,
                title: 'I am a Guest',
                subtitle: 'Register with any email',
                color: ThemeColors.primary,
                textColor: Colors.black,
                onTap: () {
                  Navigator.pushNamed(context, '/guest-signup');
                },
              ),
              
              const Spacer(),
              
              // Back to login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '← Back to Login',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: const Color(0xFF007bff),
                    fontWeight: FontWeight.w600,
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

  Widget _buildChoiceButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: textColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: textColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
