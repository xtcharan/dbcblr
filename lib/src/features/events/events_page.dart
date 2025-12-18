import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'widgets/date_filter_buttons.dart';
import 'widgets/iphone_event_list_card.dart';
import 'widgets/compact_calendar.dart';
import 'widgets/full_calendar_modal.dart';
import 'admin/create_event_page.dart';
import 'event_detail_page.dart';
import '../../shared/models/event.dart';
import '../../shared/utils/theme_colors.dart';
import '../../core/theme_provider.dart';
import '../../services/api_service.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  String _searchQuery = "";
  DateFilterType _selectedFilter = DateFilterType.upcomingEvents;
  final Set<String> _favoriteEvents = {}; // Track favorite events
  DateTime _selectedCalendarDate = DateTime.now();
  
  // Backend integration
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false; // Track login status

  // OLD: Sample events data - now loaded from backend
  final List<Event> _sampleEvents = [
    Event(
      id: "1",
      title: "Academic Conference 2025",
      description: "Annual academic conference featuring keynote speakers from top universities around the world. This year's theme focuses on 'Innovation in Research and Technology' with sessions covering artificial intelligence, machine learning, quantum computing, biotechnology, and sustainable development. Attendees will have the opportunity to participate in workshops, panel discussions, and networking sessions with leading researchers, industry experts, and fellow academics. The conference includes presentations of cutting-edge research papers, poster sessions, and collaborative research opportunities. Don't miss this chance to expand your knowledge, share your research, and connect with the global academic community. Registration includes conference materials, lunch, coffee breaks, and access to all sessions.",
      startDate: DateTime(2025, 9, 25, 9, 0),
      endDate: DateTime(2025, 9, 25, 17, 0),
      location: "Main Auditorium",
      category: "Academic",
      isHouseEvent: false,
      eventImage: "https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070&auto=format&fit=crop",
      price: 35.0,
      availableSeats: 150,
      participantCount: 1250,
    ),
    Event(
      id: "2",
      title: "Cultural Fest: Harmony 2025",
      description: "Three-day cultural extravaganza featuring music, dance, drama performances, and art exhibitions from diverse cultures around the world. Harmony 2025 celebrates the rich tapestry of global traditions through live performances, interactive workshops, cultural food stalls, and immersive experiences. Day 1 focuses on traditional music and folk dances from different continents. Day 2 showcases contemporary fusion performances blending classical and modern art forms. Day 3 features theatrical performances, storytelling sessions, and a grand finale concert with international artists. Visitors can participate in hands-on workshops including pottery making, traditional cooking, calligraphy, and textile weaving. The festival also includes a cultural marketplace where artisans from various countries will display and sell their authentic crafts, jewelry, and artwork. This is a perfect opportunity for families to explore different cultures, taste authentic cuisines, and create lasting memories together.",
      startDate: DateTime(2025, 10, 5, 10, 0),
      endDate: DateTime(2025, 10, 7, 20, 0),
      location: "Main Auditorium",
      category: "Cultural",
      isHouseEvent: false,
      eventImage: "https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?q=80&w=2070&auto=format&fit=crop",
      price: 25.0,
      availableSeats: 300,
      participantCount: 2500,
    ),
    Event(
      id: "3",
      title: "Inter-House Basketball Tournament",
      description: "Annual inter-house basketball tournament bringing together teams from all residential houses in an exciting week-long competition. This prestigious sporting event features both men's and women's divisions with preliminary rounds, quarter-finals, semi-finals, and championship games. Each house fields their best players in a battle for the coveted championship trophy and bragging rights for the year. The tournament includes skill challenges, three-point contests, and slam dunk competitions alongside the main games. Spectators can enjoy cheerleading performances, food stalls, music, and prizes throughout the week. Professional referees officiate all games, and matches are live-streamed for those who can't attend in person. The event promotes house spirit, healthy competition, athletic excellence, and community building among residents. Awards will be presented for MVP, best team spirit, most improved player, and sportsmanship. Come support your house team and be part of this thrilling basketball extravaganza that has become a beloved tradition in our community.",
      startDate: DateTime(2025, 9, 28, 9, 0),
      endDate: DateTime(2025, 9, 28, 18, 0),
      location: "Sports Complex",
      category: "Sports",
      isHouseEvent: true,
      eventImage: "https://images.unsplash.com/photo-1518063319789-7217e6706b04?q=80&w=2069&auto=format&fit=crop",
      price: 15.0,
      availableSeats: 500,
      participantCount: 1000,
    ),
    Event(
      id: "4",
      title: "Hackathon 2025: Code for Change",
      description: "24-hour coding competition focused on developing innovative solutions for real-world social and environmental challenges. Teams of developers, designers, and problem-solvers will collaborate intensively to create applications, websites, and software solutions that address pressing issues like climate change, healthcare accessibility, education inequality, and community development. The hackathon provides mentorship from industry experts, access to cutting-edge tools and APIs, and workshops on emerging technologies including AI/ML, blockchain, IoT, and cloud computing. Participants will have access to free meals, energy drinks, comfortable workspaces, and gaming areas for breaks. Judges include CTOs from leading tech companies, venture capitalists, and social impact leaders. Prizes include cash awards up to 10000 dollars, internship opportunities, incubator program admissions, and the chance to present solutions to potential investors. Whether you are a beginner or experienced developer, this event offers an incredible opportunity to learn, network, and make a meaningful impact through technology.",
      startDate: DateTime(2025, 10, 15, 9, 0),
      endDate: DateTime(2025, 10, 16, 9, 0),
      location: "Library",
      category: "Academic",
      isHouseEvent: false,
      eventImage: "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?q=80&w=2070&auto=format&fit=crop",
      price: 20.0,
      availableSeats: 100,
      participantCount: 800,
    ),
    Event(
      id: "5",
      title: "Gala Night of Hilarious Comedy at The Club",
      description: "Planning an event can be a daunting task, especially when you have guests from around the world coming to celebrate with you. Join us for an unforgettable night of comedy and entertainment.",
      startDate: DateTime(2025, 6, 17, 20, 0),
      endDate: DateTime(2025, 6, 17, 23, 0),
      location: "California, USA",
      category: "Entertainment",
      isHouseEvent: true,
      eventImage: "https://images.unsplash.com/photo-1516450360452-9312f5463805?q=80&w=2070&auto=format&fit=crop",
      price: 48.0,
      availableSeats: 256,
      participantCount: 2000,
    ),
    Event(
      id: "6",
      title: "Photography Workshop",
      description: "Comprehensive hands-on workshop covering photography basics, advanced composition techniques, and digital editing skills for photographers of all levels. This intensive session covers camera fundamentals including aperture, shutter speed, ISO settings, and manual mode operation. Learn professional composition rules like the rule of thirds, leading lines, symmetry, and framing techniques. The workshop includes practical shooting sessions in various lighting conditions - golden hour, blue hour, indoor, and studio lighting setups. Participants will practice portrait photography, landscape shots, macro photography, and street photography under expert guidance. The second half focuses on post-processing using Adobe Lightroom and Photoshop, covering color correction, exposure adjustments, noise reduction, and creative editing techniques. All participants will receive a comprehensive photography guide, preset collections, and access to an online community for continued learning. Bring your camera (DSLR, mirrorless, or smartphone) and leave with stunning photos and newfound skills to elevate your photography journey.",
      startDate: DateTime(2025, 9, 26, 14, 0),
      endDate: DateTime(2025, 9, 26, 17, 0),
      location: "Outdoor Ground",
      category: "Cultural",
      isHouseEvent: false,
      eventImage: "https://images.unsplash.com/photo-1542038784456-1ea8e935640e?q=80&w=2070&auto=format&fit=crop",
      price: 30.0,
      availableSeats: 50,
      participantCount: 150,
    ),
    Event(
      id: "7",
      title: "Career Fair 2025",
      description: "Annual recruitment drive featuring 50+ leading companies from technology, finance, healthcare, consulting, manufacturing, and startup sectors. This comprehensive career fair provides students and professionals with direct access to hiring managers, HR representatives, and industry leaders. Companies participating include Fortune 500 corporations, innovative startups, government agencies, and non-profit organizations offering positions ranging from entry-level to senior management roles. The event features company booths, on-site interviews, resume review sessions, career counseling, and professional networking opportunities. Special sessions include interview preparation workshops, LinkedIn profile optimization, salary negotiation strategies, and industry-specific career guidance. Attendees can participate in mock interviews, attend presentations about company culture and growth opportunities, and explore internship programs. Don't forget to bring multiple copies of your resume, dress professionally, and research the participating companies beforehand. This is your chance to land your dream job or make valuable connections for future opportunities.",
      startDate: DateTime(2025, 10, 20, 10, 0),
      endDate: DateTime(2025, 10, 20, 16, 0),
      location: "Main Auditorium",
      category: "Academic",
      isHouseEvent: false,
      eventImage: "https://images.unsplash.com/photo-1560523159-4a9692d222f9?q=80&w=2036&auto=format&fit=crop",
      availableSeats: 800,
      participantCount: 3500,
    ),
    Event(
      id: "8",
      title: "House Chess Tournament",
      description: "Annual chess tournament between houses.",
      startDate: DateTime(2025, 9, 27, 13, 0),
      endDate: DateTime(2025, 9, 27, 18, 0),
      location: "Library",
      category: "Sports",
      isHouseEvent: true,
      eventImage: "https://images.unsplash.com/photo-1529699211952-734e80c4d42b?q=80&w=2071&auto=format&fit=crop",
      price: 10.0,
      availableSeats: 64,
      participantCount: 200,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadEvents(); // Load events directly (no auto-login for now)
  }
  
  /// Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    final loggedIn = await _apiService.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
    });
  }
  
  /// Show login dialog
  Future<void> _showLoginDialog() async {
    final emailController = TextEditingController(text: 'admin@college.edu');
    final passwordController = TextEditingController(text: 'admin123');
    
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColors.surface(context),
          title: Text(
            'Admin Login',
            style: GoogleFonts.urbanist(
              color: ThemeColors.text(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                style: GoogleFonts.urbanist(color: ThemeColors.text(context)),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: GoogleFonts.urbanist(color: ThemeColors.textSecondary(context)),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: GoogleFonts.urbanist(color: ThemeColors.text(context)),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.urbanist(color: ThemeColors.textSecondary(context)),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.urbanist(color: ThemeColors.textSecondary(context)),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _apiService.login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  Navigator.of(context).pop(true);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login failed: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'Login',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
    
    if (result == true) {
      setState(() {
        _isLoggedIn = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✓ Logged in as admin')),
      );
    }
  }
  
  /// Logout function
  Future<void> _logout() async {
    await _apiService.logout();
    setState(() {
      _isLoggedIn = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out')),
    );
  }
  
  /// Load events from backend API
  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final eventsData = await _apiService.getEvents();
      setState(() {
        _events = eventsData.map((json) => Event.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        // Fallback to sample data if API fails
        _events = _sampleEvents;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load events from server. Using offline data.'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadEvents,
            ),
          ),
        );
      }
    }
  }
  
  void _navigateToCreateEvent([Event? eventToEdit]) async {
    // Check if logged in before creating/editing
    if (!_isLoggedIn) {
      await _showLoginDialog();
      if (!_isLoggedIn) return; // User cancelled login
    }
    
    final result = await Navigator.of(context).push<Event>(
      MaterialPageRoute(
        builder: (context) => CreateEventPage(event: eventToEdit),
        fullscreenDialog: true,
      ),
    );
    
    if (result != null) {
      try {
        if (eventToEdit != null) {
          // Update existing event via API
          await _apiService.updateEvent(
            id: result.id,
            title: result.title,
            description: result.description,
            startDate: result.startDate,
            endDate: result.endDate,
            location: result.location,
            category: result.category,
            imageUrl: result.eventImage,
            maxCapacity: result.availableSeats,
            // Payment fields
            isPaidEvent: result.isPaidEvent,
            eventAmount: result.eventAmount,
            currency: result.currency,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event updated successfully!')),
            );
          }
        } else {
          // Create new event via API
          await _apiService.createEvent(
            title: result.title,
            description: result.description,
            startDate: result.startDate,
            endDate: result.endDate,
            location: result.location,
            category: result.category,
            imageUrl: result.eventImage,
            maxCapacity: result.availableSeats,
            // Payment fields
            isPaidEvent: result.isPaidEvent,
            eventAmount: result.eventAmount,
            currency: result.currency,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event created successfully!')),
            );
          }
        }
        
        // Reload events from backend
        await _loadEvents();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Filter events based on search query and date filter
  List<Event> get _filteredEvents {
    List<Event> filtered = _events.where((event) {
      // Search filter
      final matchesSearch = event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (!matchesSearch) return false;

      // Date filter
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final weekEnd = today.add(const Duration(days: 7));
      final monthEnd = DateTime(now.year, now.month + 1, 0);
      final selectedCalendarDay = DateTime(
        _selectedCalendarDate.year,
        _selectedCalendarDate.month,
        _selectedCalendarDate.day,
      );

      final eventDate = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );

      // First check if calendar date is selected and filter by that
      if (!eventDate.isAtSameMomentAs(selectedCalendarDay) && 
          !_isSameDay(_selectedCalendarDate, today)) {
        return eventDate.isAtSameMomentAs(selectedCalendarDay);
      }

      // Then apply period filter
      switch (_selectedFilter) {
        case DateFilterType.upcomingEvents:
          return true; // Show all events for upcoming
        case DateFilterType.today:
          return eventDate.isAtSameMomentAs(today);
        case DateFilterType.tomorrow:
          return eventDate.isAtSameMomentAs(tomorrow);
        case DateFilterType.thisWeek:
          return eventDate.isAfter(today.subtract(const Duration(days: 1))) &&
                 eventDate.isBefore(weekEnd);
        case DateFilterType.thisMonth:
          return eventDate.isAfter(today.subtract(const Duration(days: 1))) &&
                 eventDate.isBefore(monthEnd.add(const Duration(days: 1)));
      }
    }).toList();

    // Sort by date
    filtered.sort((a, b) => a.startDate.compareTo(b.startDate));
    return filtered;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showFullCalendar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FullCalendarModal(
        selectedDate: _selectedCalendarDate,
        onDateSelected: (date) {
          setState(() {
            _selectedCalendarDate = date;
          });
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final filteredEvents = _filteredEvents;

    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: ThemeColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading events...',
                    style: GoogleFonts.urbanist(
                      color: ThemeColors.textSecondary(context),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
        child: Column(
          children: [
            // Compact Header with Search Bar
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
                          hintText: 'Search events...',
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
                  
                  const SizedBox(width: 12),
                  
                  // Login/Logout Button
                  GestureDetector(
                    onTap: () {
                      if (_isLoggedIn) {
                        _logout();
                      } else {
                        _showLoginDialog();
                      }
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: _isLoggedIn ? ThemeColors.primary : ThemeColors.surface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ThemeColors.cardBorder(context),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _isLoggedIn ? Icons.admin_panel_settings : Icons.login,
                        color: _isLoggedIn ? Colors.black : ThemeColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Filter button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Filter tapped!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: ThemeColors.surface(context),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: ThemeColors.cardBorder(context),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: ThemeColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // Compact Calendar
                    CompactCalendar(
                      selectedDate: _selectedCalendarDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedCalendarDate = date;
                        });
                      },
                      onMonthTap: _showFullCalendar,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Date Filter Buttons
                    DateFilterButtons(
                      selectedFilter: _selectedFilter,
                      onFilterSelected: (filter) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Events List
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          if (filteredEvents.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    size: 64,
                                    color: ThemeColors.icon(context),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No events found',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: ThemeColors.text(context),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try changing your filter or search terms',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: ThemeColors.textSecondary(context),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else
                            ...filteredEvents.map((event) => IPhoneEventListCard(
                              event: event,
                              isFavorite: _favoriteEvents.contains(event.id),
                              onFavoriteToggle: () {
                                setState(() {
                                  if (_favoriteEvents.contains(event.id)) {
                                    _favoriteEvents.remove(event.id);
                                  } else {
                                    _favoriteEvents.add(event.id);
                                  }
                                });
                              },
                              onTap: () {
                                // Navigate to event details
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EventDetailPage(event: event),
                                  ),
                                );
                              },
                              onEdit: () => _navigateToCreateEvent(event),
                              onDelete: () => _deleteEvent(event),
                            )),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateEvent(),
        backgroundColor: ThemeColors.primary,
        foregroundColor: Colors.black,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: Text(
          'Create Event',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  void _deleteEvent(Event event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColors.surface(context),
          title: Text(
            'Delete Event',
            style: GoogleFonts.urbanist(
              color: ThemeColors.text(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${event.title}"?',
            style: GoogleFonts.urbanist(
              color: ThemeColors.text(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.urbanist(
                  color: ThemeColors.textSecondary(context),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Delete',
                style: GoogleFonts.urbanist(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
    
    if (confirmed == true) {
      try {
        await _apiService.deleteEvent(event.id);
        await _loadEvents(); // Reload from backend
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event deleted successfully'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting event: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
