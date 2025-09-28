import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'models/department.dart';
import 'widgets/enhanced_club_card.dart';
import 'club_detail_page.dart';
import '../../shared/utils/theme_colors.dart';
import '../../core/theme_provider.dart';

class DepartmentClubsPage extends StatelessWidget {
  final Department department;

  const DepartmentClubsPage({
    super.key,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Compact Header with Back Button (same style as events)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                        Icons.arrow_back_ios,
                        color: ThemeColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Title
                  Expanded(
                    child: Text(
                      department.code,
                      style: GoogleFonts.urbanist(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.text(context),
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
                      const SizedBox(height: 10),
                      
                      // Department Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              department.primaryColor,
                              department.primaryColor.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: department.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    department.icon,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        department.name,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        department.description,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _HeaderStat('${department.activeClubs}', 'Clubs'),
                                const SizedBox(width: 24),
                                _HeaderStat('${department.totalMembers}', 'Members'),
                                const SizedBox(width: 24),
                                _HeaderStat('${department.totalEvents}', 'Events'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Club Cards Header
                      Row(
                        children: [
                          Text(
                            'Club',
                            style: GoogleFonts.urbanist(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.text(context),
                            ),
                          ),
                          const Spacer(),
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
                              '${department.activeClubs} Active',
                              style: GoogleFonts.urbanist(
                                color: ThemeColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Club Cards
                      if (department.clubs.isNotEmpty)
                        ...department.clubs.map((club) => 
                          EnhancedClubCard(
                            club: club,
                            onTap: () => _navigateToClubDetail(context, club),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: ThemeColors.cardBackground(context),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ThemeColors.cardBorder(context),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.groups_outlined,
                                size: 48,
                                color: ThemeColors.iconSecondary(context),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Active Clubs',
                                style: GoogleFonts.urbanist(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: ThemeColors.text(context),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This department currently has no active clubs.',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: ThemeColors.textSecondary(context),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 30),
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

  void _navigateToClubDetail(BuildContext context, club) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubDetailPage(
          departmentCode: club.departmentCode,
          clubName: club.name,
          icon: club.icon,
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeaderStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.urbanist(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
