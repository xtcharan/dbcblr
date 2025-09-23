import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/dashboard/dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swo',
      theme: AppTheme.lightTheme,
      home: const DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
