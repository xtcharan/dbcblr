import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/theme_provider.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/welcome_page.dart';
import 'features/auth/signup_choice_page.dart';
import 'features/auth/student_activation_page.dart';
import 'features/auth/dbc_onboarding_page.dart';
import 'features/auth/guest_signup_page.dart';
import 'features/auth/otp_verification_page.dart';
import 'features/auth/profile_personalization_page.dart';
import 'features/auth/admin_login_page.dart';
import 'services/api_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'DBC SWO',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            // Check if user is logged in on startup
            home: FutureBuilder<bool>(
              future: ApiService().isLoggedIn(),
              builder: (context, snapshot) {
                // Show loading while checking auth
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                // Navigate based on auth status
                final isLoggedIn = snapshot.data ?? false;
                // Show welcome page for first-time users, login for returning users
                return isLoggedIn ? const DashboardPage() : const WelcomePage();
              },
            ),
            // Define routes for navigation
            routes: {
              '/welcome': (context) => const WelcomePage(),
              '/login': (context) => const LoginPage(),
              '/signup-choice': (context) => const SignupChoicePage(),
              '/student-activation': (context) => const StudentActivationPage(),
              '/dbc-onboarding': (context) => const DBCOnboardingPage(),
              '/guest-signup': (context) => const GuestSignupPage(),
              '/otp-verification': (context) => const OTPVerificationPage(),
              '/profile-personalization': (context) => const ProfilePersonalizationPage(),
              '/admin-login': (context) => const AdminLoginPage(),
              '/home': (context) => const DashboardPage(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
