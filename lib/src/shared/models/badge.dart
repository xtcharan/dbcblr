class Badge {
  final String id;
  final String title;
  final String description;
  final String icon; // emoji for now
  final String tier; // bronze | silver | gold | platinum
  final DateTime? earnedOn; // null = locked

  const Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tier,
    this.earnedOn,
  });

  // fake starter pack
  static List<Badge> fakeList() => [
    Badge(
      id: 'event_champ',
      title: 'Event Champion',
      description: 'Win 1st place in 3 events',
      icon: '🏆',
      tier: 'gold',
      earnedOn: DateTime(2024, 12, 15),
    ),
    Badge(
      id: 'house_hero',
      title: 'House Hero',
      description: 'Earn 1000+ house points',
      icon: '🛡️',
      tier: 'silver',
      earnedOn: DateTime(2024, 11, 20),
    ),
    Badge(
      id: 'social_butterfly',
      title: 'Social Butterfly',
      description: 'Join 5 clubs',
      icon: '🦋',
      tier: 'bronze',
      earnedOn: DateTime(2024, 10, 5),
    ),
    // locked examples
    Badge(
      id: 'tech_master',
      title: 'Tech Master',
      description: 'Win 3 tech events',
      icon: '💻',
      tier: 'platinum',
      earnedOn: null,
    ),
  ];
}
