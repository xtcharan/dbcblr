import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../shared/models/user.dart';
import '../../shared/models/event.dart';
import '../../shared/utils/theme_colors.dart';
import '../../core/theme_provider.dart';
import 'widgets/iphone_event_card.dart';
import 'widgets/iphone_search_bar.dart';
import 'widgets/iphone_categories_section.dart';
import '../../shared/services/events_provider.dart';
import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Get current user - replace with actual authentication later
  final User currentUser = User.fake();

  // Get events from provider
  late List<Event> popularEvents;
  late List<String> categories;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    popularEvents = EventsProvider.getPopularEvents();
    categories = EventsProvider.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  // Welcome Message
                  Expanded(
                    child: Text(
                      'Welcome back ${currentUser.firstName}',
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.text(context),
                      ),
                    ),
                  ),
                  
                  // Hamburger Menu
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
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Search Bar
                    IPhoneSearchBar(
                      onFilterTap: () {
                        // Handle filter tap
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Filter tapped!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Categories Section
                    IPhoneCategoriesSection(
                      categories: categories,
                      selectedCategory: selectedCategory,
                      onCategoryTap: (category) {
                        setState(() {
                          if (selectedCategory == category) {
                            // Deselect if already selected
                            selectedCategory = null;
                            popularEvents = EventsProvider.getPopularEvents();
                          } else {
                            // Select new category
                            selectedCategory = category;
                            popularEvents = EventsProvider.getEventsByCategory(category);
                          }
                        });
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Popular Events Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            'Popular Events',
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.text(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '🔥',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Popular Events Cards
                    SizedBox(
                      height: 380,
                      child: popularEvents.isEmpty
                          ? Center(
                              child: Text(
                                'No popular events found',
                                style: GoogleFonts.urbanist(
                                  color: ThemeColors.textSecondary(context),
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: popularEvents.length,
                              itemBuilder: (context, index) {
                                final event = popularEvents[index];
                                return IPhoneEventCard(
                                  event: event,
                                  isFavorite: false,
                                  onFavoriteToggle: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Added ${event.title} to favorites',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  onJoinPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Joined ${event.title}!',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                );
                              },
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
    );
  }
}
