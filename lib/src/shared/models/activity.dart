class Activity {
  final String id;
  final String title;
  final String house;
  final String houseColorHex; // same hex we already use
  final String category; // sports | academic | cultural | community | science
  final int points;
  final DateTime timestamp; // utc

  const Activity({
    required this.id,
    required this.title,
    required this.house,
    required this.houseColorHex,
    required this.category,
    required this.points,
    required this.timestamp,
  });

  // fake chronological feed (newest first)
  static List<Activity> fakeFeed() {
    final now = DateTime.now();
    return [
      Activity(
        id: 'act_1',
        title: 'Inter-House Cricket Championship',
        house: 'Ruby',
        houseColorHex: '#FF0000',
        category: 'sports',
        points: 50,
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      Activity(
        id: 'act_2',
        title: 'Science Fair 2025',
        house: 'Emerald',
        houseColorHex: '#008000',
        category: 'science',
        points: 40,
        timestamp: now.subtract(const Duration(hours: 5)),
      ),
      Activity(
        id: 'act_3',
        title: 'Cultural Dance Fest',
        house: 'Topaz',
        houseColorHex: '#FFA500',
        category: 'cultural',
        points: 30,
        timestamp: now.subtract(const Duration(hours: 8)),
      ),
      Activity(
        id: 'act_4',
        title: 'Community Clean-up Drive',
        house: 'Sapphire',
        houseColorHex: '#0000FF',
        category: 'community',
        points: 35,
        timestamp: now.subtract(const Duration(hours: 12)),
      ),
      Activity(
        id: 'act_5',
        title: 'Debate Competition',
        house: 'Ruby',
        houseColorHex: '#FF0000',
        category: 'academic',
        points: 25,
        timestamp: now.subtract(const Duration(hours: 15)),
      ),
    ];
  }
}
