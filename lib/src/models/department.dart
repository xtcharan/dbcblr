/// Department model matching backend structure
class Department {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? iconName;
  final String colorHex;
  final int totalMembers;
  final int totalClubs;
  final int totalEvents;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Department({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.logoUrl,
    this.iconName,
    required this.colorHex,
    required this.totalMembers,
    required this.totalClubs,
    required this.totalEvents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      iconName: json['icon_name'] as String?,
      colorHex: json['color_hex'] as String? ?? '#4F46E5',
      totalMembers: json['total_members'] as int? ?? 0,
      totalClubs: json['total_clubs'] as int? ?? 0,
      totalEvents: json['total_events'] as int? ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (iconName != null) 'icon_name': iconName,
      'color_hex': colorHex,
      'total_members': totalMembers,
      'total_clubs': totalClubs,
      'total_events': totalEvents,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
