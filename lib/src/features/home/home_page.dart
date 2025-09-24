import 'package:flutter/material.dart';
import '../../shared/models/user.dart';
import '../../shared/models/event.dart';
import '../../shared/widgets/event_card.dart';
import '../../shared/widgets/category_chip.dart';
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
    // Use textScaler.scale(14) instead of the deprecated textScaleFactor
    final textScaler = MediaQuery.of(context).textScaler;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with dark gradient
          SliverAppBar(
            expandedHeight:
                MediaQuery.of(context).size.height * 0.15, // Responsive height
            pinned: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.8), // 80% opacity black
                    Color.fromRGBO(0, 0, 0, 0.6), // 60% opacity black
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(
                  left: 16,
                  bottom: 16,
                  right: 16,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DBC SWO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: textScaler.scale(14),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate directly to profile page
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const ProfilePage()),
                        );
                      },
                      child: CircleAvatar(
                        radius:
                            MediaQuery.of(context).size.height *
                            0.02, // Responsive radius based on screen height
                        backgroundImage: NetworkImage(currentUser.avatarUrl),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate directly to profile page
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ProfilePage()),
                            );
                          },
                          child: Text(
                            'Hello ${currentUser.firstName}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: textScaler.scale(14),
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.grey[400],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discover Amazing Events',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: textScaler.scale(
                              14 * 1.5,
                            ), // Larger text but still responsive
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Find amazing events',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // Popular Events Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Popular Events ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: textScaler.scale(14),
                              ),
                            ),
                            Text(
                              '🔥',
                              style: TextStyle(fontSize: textScaler.scale(14)),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all events page
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),

                  // Horizontal scrolling event cards
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Use LayoutBuilder instead of MediaQuery
                      return Container(
                        height:
                            constraints.maxWidth *
                            0.7, // Responsive height based on parent width
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.35,
                        ),
                        child: popularEvents.isEmpty
                            ? const Center(
                                child: Text(
                                  'No events found in this category',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                clipBehavior: Clip.none,
                                itemCount: popularEvents.length,
                                itemBuilder: (context, index) {
                                  final event = popularEvents[index];
                                  return EventCard(
                                    event: event,
                                    isFavorite:
                                        false, // Replace with actual favorite status
                                    onFavoriteToggle: () {
                                      // Implement favorite toggle functionality
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Added ${event.title} to favorites',
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      );
                    },
                  ),

                  // Category Events Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category Events',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: textScaler.scale(14),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to categories page
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),

                  // Horizontal scrolling category chips
                  SizedBox(
                    height: 50,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return CategoryChip(
                            category: category,
                            isSelected: selectedCategory == category,
                            onTap: () {
                              setState(() {
                                if (selectedCategory == category) {
                                  // Deselect if already selected
                                  selectedCategory = null;
                                  popularEvents =
                                      EventsProvider.getPopularEvents();
                                } else {
                                  // Select new category
                                  selectedCategory = category;
                                  popularEvents =
                                      EventsProvider.getEventsByCategory(
                                        category,
                                      );
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
