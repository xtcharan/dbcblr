import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/theme_provider.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/auth/login_page.dart';
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
                return isLoggedIn ? const DashboardPage() : const LoginPage();
              },
            ),
            // Define routes for navigation
            routes: {
              '/login': (context) => const LoginPage(),
              '/home': (context) => const DashboardPage(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
