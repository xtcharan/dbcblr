/// User type enumeration
enum UserType { student, guest }

/// Education level for guest users
enum EducationLevel { school, pu, college }

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final DateTime? dob;
  final String? avatarPath; // Local file path for uploaded avatar
  final String houseId; // "ruby", "sapphire", etc.
  
  // Academic info (DBC students)
  final String? studentId;
  final String? year;
  final String? semester;
  final String? course; // Department/Course
  final String? clubName; // Auto-assigned based on department
  
  // User type
  final UserType userType;
  
  // Guest-specific fields
  final EducationLevel? educationLevel;
  final String? institutionName; // School/College name for guests
  final String? className; // For school students
  final String? section; // Optional, for school
  final String? stream; // PCMB/HEBA for PU

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.dob,
    this.avatarPath,
    required this.houseId,
    this.studentId,
    this.year,
    this.semester,
    this.course,
    this.clubName,
    this.userType = UserType.student,
    this.educationLevel,
    this.institutionName,
    this.className,
    this.section,
    this.stream,
  });

  String get fullName => '$firstName $lastName';

  // Factory for DBC student
  factory User.fake() => User(
    id: 'usr_123',
    firstName: 'Joel',
    lastName: 'Thankan',
    email: 'joel.thankan@dbcblr.edu.in',
    phone: '+91 98765 43210',
    dob: DateTime(2003, 5, 15),
    houseId: 'sapphire',
    studentId: 'DBC2023001',
    year: '2nd Year',
    semester: '4',
    course: 'BCA',
    clubName: 'Tech Club',
    userType: UserType.student,
  );

  // Factory for guest user
  factory User.fakeGuest() => User(
    id: 'guest_456',
    firstName: 'Priya',
    lastName: 'Sharma',
    email: 'priya.sharma@gmail.com',
    phone: '+91 87654 32109',
    dob: DateTime(2005, 8, 20),
    houseId: '',
    userType: UserType.guest,
    educationLevel: EducationLevel.pu,
    institutionName: 'St. Joseph\'s PU College',
    stream: 'PCMB',
    course: 'Science',
    year: '2 PU',
  );
}
