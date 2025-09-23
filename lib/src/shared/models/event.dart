class Event {
  final String id;
  final String title;
  final String date; // ISO
  final String image;
  final int spotsCurrent;
  final int spotsTotal;
  final String category; // "academic" | "cultural" | "sports" | "house"
  final String? houseName; // null unless category=="house"
  final String location;
  final String time; // human "4:00 PM - 6:00 PM"

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
    required this.spotsCurrent,
    required this.spotsTotal,
    required this.category,
    this.houseName,
    required this.location,
    required this.time,
  });

  // prettier fake data
  factory Event.fake(int i) {
    final cats = ['academic', 'cultural', 'sports', 'house'];
    final cat = cats[i % 4];
    final houses = ['Ruby', 'Sapphire', 'Topaz', 'Emerald'];
    return Event(
      id: 'evt_$i',
      title: '${cat[0].toUpperCase()}${cat.substring(1)} Fest $i',
      date: '2025-09-${25 + (i % 5)}',
      image: 'https://picsum.photos/400/250?random=$i',
      spotsCurrent: 15 + i * 3,
      spotsTotal: 50,
      category: cat,
      houseName: cat == 'house' ? houses[i % 4] : null,
      location: 'Auditorium ${i % 3 + 1}',
      time: '${4 + (i % 3)}:00 PM - ${6 + (i % 3)}:00 PM',
    );
  }
}
