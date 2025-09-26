import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../shared/models/event.dart';
import '../../shared/utils/theme_colors.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isDescriptionExpanded = false;
  
  // Sample guest data
  final List<Map<String, dynamic>> _guestData = [
    {
      'name': 'John Doe',
      'designation': 'CEO at TechCorp',
      'initials': 'JD',
      'color': Colors.blue.shade100,
      'textColor': Colors.blue.shade700,
    },
    {
      'name': 'Sarah Wilson',
      'designation': 'CTO at DevCorp',
      'initials': 'SW',
      'color': Colors.purple.shade100,
      'textColor': Colors.purple.shade700,
    },
    {
      'name': 'Mike Johnson',
      'designation': 'Designer',
      'initials': 'MJ',
      'color': Colors.green.shade100,
      'textColor': Colors.green.shade700,
    },
    {
      'name': 'Lisa Chen',
      'designation': 'Product Manager',
      'initials': 'LC',
      'color': Colors.orange.shade100,
      'textColor': Colors.orange.shade700,
    },
    {
      'name': 'David Park',
      'designation': 'Engineer',
      'initials': 'DP',
      'color': Colors.red.shade100,
      'textColor': Colors.red.shade700,
    },
    {
      'name': 'Emma Davis',
      'designation': 'Marketing',
      'initials': 'ED',
      'color': Colors.teal.shade100,
      'textColor': Colors.teal.shade700,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dateTimeFormatter = DateFormat('EEEE, MMM dd, yyyy • HH:mm');
    
    final fullDateTime = dateTimeFormatter.format(widget.event.startDate);

    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: CustomScrollView(
        slivers: [
          // App Bar with Event Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: ThemeColors.surface(context),
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Event Image
                  widget.event.eventImage != null
                      ? Image.network(
                          widget.event.eventImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: ThemeColors.surface(context),
                              child: Icon(
                                Icons.event,
                                size: 80,
                                color: ThemeColors.iconSecondary(context),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: ThemeColors.surface(context),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ThemeColors.primary,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: ThemeColors.surface(context),
                          child: Icon(
                            Icons.event,
                            size: 80,
                            color: ThemeColors.iconSecondary(context),
                          ),
                        ),
                  
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    widget.event.title,
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.text(context),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Available seats
                  Text(
                    widget.event.availableSeats != null 
                        ? '${widget.event.availableSeats} seats available' 
                        : 'Limited seats available',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: ThemeColors.textSecondary(context),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date and Time
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: ThemeColors.icon(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        fullDateTime,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: ThemeColors.text(context),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: ThemeColors.icon(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.event.location,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: ThemeColors.text(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // About Event Section
                  Text(
                    'About Event',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.text(context),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    widget.event.description,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: ThemeColors.textSecondary(context),
                      height: 1.5,
                    ),
                    maxLines: _isDescriptionExpanded ? null : 2,
                    overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Read more link
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDescriptionExpanded = !_isDescriptionExpanded;
                      });
                    },
                    child: Text(
                      _isDescriptionExpanded ? 'read less...' : 'read more...',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: ThemeColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // iPhone-style Guest Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeColors.surface(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ThemeColors.cardBorder(context),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Guest Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Guest',
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: ThemeColors.text(context),
                              ),
                            ),
                            Text(
                              'view all',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: ThemeColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Horizontal Scrollable Guest Profiles
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _guestData.length,
                            padding: const EdgeInsets.only(right: 8),
                            itemBuilder: (context, index) {
                              final guest = _guestData[index];
                              return Container(
                                width: 80,
                                margin: EdgeInsets.only(right: index < _guestData.length - 1 ? 16 : 0),
                                child: Column(
                                  children: [
                                    // Profile Picture
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: guest['color'] as Color,
                                      child: Text(
                                        guest['initials'] as String,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: guest['textColor'] as Color,
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 8),
                                    
                                    // Guest Name
                                    Text(
                                      guest['name'] as String,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: ThemeColors.text(context),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    // Guest Designation
                                    Text(
                                      guest['designation'] as String,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 10,
                                        color: ThemeColors.textSecondary(context),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Enroll Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF446AEF),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF446AEF).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          // Handle enroll action
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              // Mini Profiles Section
                              Row(
                                children: [
                                  // First profile
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    child: Text(
                                      'A',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  
                                  Transform.translate(
                                    offset: const Offset(-6, 0),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                                      child: Text(
                                        'B',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  Transform.translate(
                                    offset: const Offset(-12, 0),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                                      child: Text(
                                        '15+',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const Spacer(),
                              
                              // Enroll Now Text
                              Text(
                                'enroll now >>>',
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
