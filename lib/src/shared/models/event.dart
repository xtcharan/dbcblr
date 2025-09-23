class Event {
  final String id;
  final String title;
  final String date; // ISO string
  final String image;
  final int spotsLeft;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
    required this.spotsLeft,
  });

  // fake factory for now
  factory Event.fake() => Event(
    id: 'evt_${DateTime.now().millisecondsSinceEpoch}',
    title: 'AI Workshop',
    date: '2025-09-25T18:00:00Z',
    image:
        'https://picsum.photos/200/100?random=${DateTime.now().millisecondsSinceEpoch}',
    spotsLeft: 23,
  );
}
