/// Club member model matching backend structure
class ClubMember {
  final String id;
  final String clubId;
  final String userId;
  final String role;
  final String? position;
  final DateTime joinedAt;
  final DateTime createdAt;
  final User? user; // Populated in ClubMemberWithUser

  const ClubMember({
    required this.id,
    required this.clubId,
    required this.userId,
    required this.role,
    this.position,
    required this.joinedAt,
    required this.createdAt,
    this.user,
  });

  factory ClubMember.fromJson(Map<String, dynamic> json) {
    return ClubMember(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String? ?? 'member',
      position: json['position'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'club_id': clubId,
      'user_id': userId,
      'role': role,
      if (position != null) 'position': position,
      'joined_at': joinedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      if (user != null) 'user': user!.toJson(),
    };
  }
}

/// User model for club member details
class User {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? avatarUrl;
  final String? department;
  final int? year;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.avatarUrl,
    this.department,
    this.year,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String? ?? 'student',
      avatarUrl: json['avatar_url'] as String?,
      department: json['department'] as String?,
      year: json['year'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (department != null) 'department': department,
      if (year != null) 'year': year,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
