class House {
  final String id;
  final String name;
  final String colorHex;
  final String mascot;
  final int points;
  final String status; // Rising, Stable, Falling

  const House({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.mascot,
    required this.points,
    required this.status,
  });

  // fake data matching DBC names
  static List<House> fakeList() => [
    House(
      id: 'ruby',
      name: 'Ruby Rhinos',
      colorHex: '#FF0000',
      mascot: '🦏',
      points: 1240,
      status: 'Rising',
    ),
    House(
      id: 'sapphire',
      name: 'Sapphire Sharks',
      colorHex: '#0000FF',
      mascot: '🦈',
      points: 1180,
      status: 'Stable',
    ),
    House(
      id: 'topaz',
      name: 'Topaz Tigers',
      colorHex: '#FFA500',
      mascot: '🐅',
      points: 1320,
      status: 'Rising',
    ),
    House(
      id: 'emerald',
      name: 'Emerald Eagles',
      colorHex: '#008000',
      mascot: '🦅',
      points: 1150,
      status: 'Falling',
    ),
  ];
}
