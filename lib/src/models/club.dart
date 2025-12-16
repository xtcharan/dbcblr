/// Club model matching backend structure
class Club {
  final String id;
  final String? departmentId;
  final String name;
  final String? tagline;
  final String? description;
  final String? logoUrl;
  final String primaryColor;
  final String secondaryColor;
  final int memberCount;
  final int eventCount;
  final int awardsCount;
  final double rating;
  final String? email;
  final String? phone;
  final String? website;
  final Map<String, dynamic>? socialLinks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Club({
    required this.id,
    this.departmentId,
    required this.name,
    this.tagline,
    this.description,
    this.logoUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.memberCount,
    required this.eventCount,
    required this.awardsCount,
    required this.rating,
    this.email,
    this.phone,
    this.website,
    this.socialLinks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] as String,
      departmentId: json['department_id'] as String?,
      name: json['name'] as String,
      tagline: json['tagline'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      primaryColor: json['primary_color'] as String? ?? '#4F46E5',
      secondaryColor: json['secondary_color'] as String? ?? '#818CF8',
      memberCount: json['member_count'] as int? ?? 0,
      eventCount: json['event_count'] as int? ?? 0,
      awardsCount: json['awards_count'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      socialLinks: json['social_links'] as Map<String, dynamic>?,
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
      if (departmentId != null) 'department_id': departmentId,
      'name': name,
      if (tagline != null) 'tagline': tagline,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logo_url': logoUrl,
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
      'member_count': memberCount,
      'event_count': eventCount,
      'awards_count': awardsCount,
      'rating': rating,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (socialLinks != null) 'social_links': socialLinks,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
