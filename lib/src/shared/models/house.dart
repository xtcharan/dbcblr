/// House model for the school house system
class House {
  final String id;
  final String name;
  final String? color;
  final String colorHex; // For UI compatibility (same as color but guaranteed non-null)
  final String? description;
  final String? logoUrl;
  final String mascot; // Emoji or icon for the house
  final int points;
  final String status; // 'Rising', 'Stable', 'Falling'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<HouseRole> roles;

  const House({
    required this.id,
    required this.name,
    this.color,
    this.colorHex = '#4F46E5',
    this.description,
    this.logoUrl,
    this.mascot = '🏠',
    required this.points,
    this.status = 'Stable',
    required this.createdAt,
    this.updatedAt,
    this.roles = const [],
  });

  factory House.fromJson(Map<String, dynamic> json) {
    final colorValue = json['color'] ?? '#4F46E5';
    return House(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'],
      colorHex: colorValue.startsWith('#') ? colorValue : '#$colorValue',
      description: json['description'],
      logoUrl: json['logo_url'],
      mascot: json['mascot'] ?? '🏠',
      points: json['points'] ?? 0,
      status: json['status'] ?? 'Stable',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      roles: json['roles'] != null
          ? (json['roles'] as List)
              .map((r) => HouseRole.fromJson(r))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color ?? colorHex,
      'description': description,
      'logo_url': logoUrl,
      'mascot': mascot,
      'points': points,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get color as Color object from hex string
  int get colorValue {
    String hex = colorHex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return int.parse(hex, radix: 16);
  }

  /// Fake data for development/testing
  static List<House> fakeList() => [
    House(
      id: 'ruby',
      name: 'Ruby Rhinos',
      colorHex: '#FF0000',
      mascot: '🦏',
      points: 1240,
      status: 'Rising',
      createdAt: DateTime.now(),
    ),
    House(
      id: 'sapphire',
      name: 'Sapphire Sharks',
      colorHex: '#0000FF',
      mascot: '🦈',
      points: 1180,
      status: 'Stable',
      createdAt: DateTime.now(),
    ),
    House(
      id: 'topaz',
      name: 'Topaz Tigers',
      colorHex: '#FFA500',
      mascot: '🐅',
      points: 1320,
      status: 'Rising',
      createdAt: DateTime.now(),
    ),
    House(
      id: 'emerald',
      name: 'Emerald Eagles',
      colorHex: '#008000',
      mascot: '🦅',
      points: 1150,
      status: 'Falling',
      createdAt: DateTime.now(),
    ),
  ];
}


/// House role model - admin-defined roles with member names
class HouseRole {
  final String id;
  final String houseId;
  final String memberName;
  final String roleTitle;
  final int displayOrder;
  final DateTime createdAt;

  const HouseRole({
    required this.id,
    required this.houseId,
    required this.memberName,
    required this.roleTitle,
    this.displayOrder = 0,
    required this.createdAt,
  });

  factory HouseRole.fromJson(Map<String, dynamic> json) {
    return HouseRole(
      id: json['id'] ?? '',
      houseId: json['house_id'] ?? '',
      memberName: json['member_name'] ?? '',
      roleTitle: json['role_title'] ?? '',
      displayOrder: json['display_order'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member_name': memberName,
      'role_title': roleTitle,
      'display_order': displayOrder,
    };
  }
}
