class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String houseId; // "ruby", "sapphire", etc.
  final String avatarUrl;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.houseId,
    required this.avatarUrl,
  });

  // fake student
  factory User.fake() => const User(
    id: 'usr_123',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@dbc.edu.in',
    houseId: 'sapphire',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
  );
}
