import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'data/clubs_data.dart';
import 'department_clubs_page.dart';
import '../../shared/utils/theme_colors.dart';
import '../../core/theme_provider.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({super.key});

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = "";

  // Define department data with proper mapping
  final List<Map<String, dynamic>> _departments = [
    {
      'code': 'BCA',
      'name': 'Bachelor of Computer Applications',
      'clubName': 'BITBLAZE',
      'description': 'Innovation Through Code',
      'icon': Icons.computer,
      'color': Colors.indigo,
      'memberCount': 125,
    },
    {
      'code': 'BCOM',
      'name': 'Bachelor of Commerce',
      'clubName': 'VANIJYA',
      'description': 'Commerce & Finance Hub',
      'icon': Icons.account_balance,
      'color': Colors.green,
      'memberCount': 78,
    },
    {
      'code': 'BBA',
      'name': 'Bachelor of Business Administration',
      'clubName': 'SYNAPSE',
      'description': "Leading Tomorrow's Business",
      'icon': Icons.business,
      'color': Colors.orange,
      'memberCount': 89,
    },
    {
      'code': 'BA',
      'name': 'Bachelor of Arts',
      'clubName': 'COLOS',
      'description': 'Colors of Creativity',
      'icon': Icons.palette,
      'color': Colors.purple,
      'memberCount': 156,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Compact Header with Search Bar (same style as events)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  // Hamburger menu
                  GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: ThemeColors.surface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ThemeColors.cardBorder(context),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: ThemeColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Search Bar (compact)
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: ThemeColors.inputBackground(context),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: ThemeColors.inputBorder(context),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: GoogleFonts.urbanist(
                          color: ThemeColors.text(context),
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search clubs...',
                          hintStyle: GoogleFonts.urbanist(
                            color: ThemeColors.textSecondary(context),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: ThemeColors.icon(context),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Theme Toggle Button
                  GestureDetector(
                    onTap: () {
                      context.read<ThemeProvider>().toggleTheme();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: ThemeColors.surface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ThemeColors.cardBorder(context),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Theme.of(context).brightness == Brightness.light
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: ThemeColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Page Title
                      Text(
                        'Clubs',
                        style: GoogleFonts.urbanist(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.text(context),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Subtitle
                      Text(
                        'Explore clubs by department and discover your passion.',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: ThemeColors.textSecondary(context),
                          height: 1.4,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Department Boxes
                      ...(_departments.where((dept) => 
                        dept['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        dept['clubName'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
                      ).map((department) => _buildDepartmentBox(department))),
                      
                      // BSW Department with special handling (no club)
                      if (_searchQuery.isEmpty || 
                          'bachelor of social work'.contains(_searchQuery.toLowerCase()) ||
                          'bsw'.contains(_searchQuery.toLowerCase()))
                        _buildBSWDepartmentBox(),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentBox(Map<String, dynamic> department) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.cardBorder(context).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDepartmentClubs(department),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon with colored background
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: (department['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    department['icon'],
                    color: department['color'],
                    size: 32,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Department code and name
                      Text(
                        department['code'],
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.text(context),
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        department['name'],
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: ThemeColors.textSecondary(context),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Club info
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${department['clubName']} • ${department['memberCount']} members',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.primary,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        department['description'],
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          color: ThemeColors.textTertiary(context),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: ThemeColors.iconSecondary(context),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBSWDepartmentBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeColors.cardBorder(context),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.cardBorder(context).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Icon with colored background
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.volunteer_activism,
                color: Colors.red,
                size: 32,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Department code and name
                  Text(
                    'BSW',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.text(context),
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    'Bachelor of Social Work',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: ThemeColors.textSecondary(context),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // No club available
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.textTertiary(context).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'No active clubs',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.textTertiary(context),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Service Before Self',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: ThemeColors.textTertiary(context),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDepartmentClubs(Map<String, dynamic> department) {
    // Get the actual department from ClubsData
    final departments = ClubsData.getDepartments();
    final actualDepartment = departments.firstWhere(
      (dept) => dept.code == department['code'],
      orElse: () => departments.first,
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepartmentClubsPage(department: actualDepartment),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
