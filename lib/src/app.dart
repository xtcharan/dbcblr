import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/dashboard/dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DBC SWO',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Force dark theme for Eventonic design
      home: const DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
