class MyEvent {
  final String id;
  final String title;
  final String category; // academic | cultural | sports | house
  final String image;
  final DateTime completedAt;
  final int pointsEarned;

  const MyEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.completedAt,
    required this.pointsEarned,
  });

  // fake history (only COMPLETED events)
  static List<MyEvent> fakeHistory() => [
    MyEvent(
      id: 'mev_1',
      title: 'Inter-House Cricket Finals',
      category: 'sports',
      image: 'https://picsum.photos/200/120?random=1',
      completedAt: DateTime.now().subtract(const Duration(days: 3)),
      pointsEarned: 50,
    ),
    MyEvent(
      id: 'mev_2',
      title: 'AI Workshop Series',
      category: 'academic',
      image: 'https://picsum.photos/200/120?random=2',
      completedAt: DateTime.now().subtract(const Duration(days: 7)),
      pointsEarned: 30,
    ),
    MyEvent(
      id: 'mev_3',
      title: 'Cultural Dance Fest',
      category: 'cultural',
      image: 'https://picsum.photos/200/120?random=3',
      completedAt: DateTime.now().subtract(const Duration(days: 14)),
      pointsEarned: 40,
    ),
  ];
}
