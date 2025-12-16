import 'package:flutter/material.dart';
import 'pages/departments_list_page.dart';

/// Clubs page - now redirects to the new API-integrated departments page
class ClubsPage extends StatelessWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to the new departments list page with proper API integration
    return const DepartmentsListPage();
  }
}
