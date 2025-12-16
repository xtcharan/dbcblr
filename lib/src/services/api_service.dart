import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// API Service for making HTTP requests to the backend
class ApiService {
  // Backend URL Configuration:
  // - Android Emulator: http://10.0.2.2:8080
  // - iOS Simulator: http://localhost:8080
  // - Physical Device: http://YOUR_COMPUTER_IP:8080
  // - Production: https://your-backend-url.com
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30), // Increased from 10s
          receiveTimeout: const Duration(seconds: 30), // Increased from 10s
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )),
        _storage = const FlutterSecureStorage() {
    // Add interceptor to attach JWT token to all requests
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 errors (unauthorized) - token might be expired
        if (error.response?.statusCode == 401) {
          await logout();
          // You can navigate to login page here
        }
        return handler.next(error);
      },
    ));
  }

  // ==================== AUTH ENDPOINTS ====================

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? department,
    int? year,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'full_name': fullName,
        if (department != null) 'department': department,
        if (year != null) 'year': year,
      });
      
      if (response.data['success'] == true) {
        // Save tokens
        final data = response.data['data'];
        await _storage.write(key: 'access_token', value: data['access_token']);
        await _storage.write(key: 'refresh_token', value: data['refresh_token']);
        return data;
      }
      
      throw Exception(response.data['error'] ?? 'Registration failed');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      if (response.data['success'] == true) {
        // Save tokens
        final data = response.data['data'];
        await _storage.write(key: 'access_token', value: data['access_token']);
        await _storage.write(key: 'refresh_token', value: data['refresh_token']);
        return data;
      }
      
      throw Exception(response.data['error'] ?? 'Login failed');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout user (clear tokens)
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  /// Get current user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/profile');
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch profile');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== EVENTS ENDPOINTS ====================

  /// Get all events (public)
  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      final response = await _dio.get('/events');
      
      if (response.data['success'] == true) {
        final List<dynamic> events = response.data['data'] ?? [];
        return events.cast<Map<String, dynamic>>();
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch events');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get single event by ID
  Future<Map<String, dynamic>> getEvent(String id) async {
    try {
      final response = await _dio.get('/events/$id');
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch event');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create event (admin only)
  Future<Map<String, dynamic>> createEvent({
    required String title,
    String? description,
    String? imageUrl,
    required DateTime startDate,
    required DateTime endDate,
    String? location,
    String? category,
    int? maxCapacity,
  }) async {
    try {
      final response = await _dio.post('/admin/events', data: {
        'title': title,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        if (location != null) 'location': location,
        if (category != null) 'category': category,
        if (maxCapacity != null) 'max_capacity': maxCapacity,
      });
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to create event');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update event (admin only)
  Future<Map<String, dynamic>> updateEvent({
    required String id,
    required String title,
    String? description,
    String? imageUrl,
    required DateTime startDate,
    required DateTime endDate,
    String? location,
    String? category,
    int? maxCapacity,
  }) async {
    try {
      final response = await _dio.put('/admin/events/$id', data: {
        'title': title,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        if (location != null) 'location': location,
        if (category != null) 'category': category,
        if (maxCapacity != null) 'max_capacity': maxCapacity,
      });
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to update event');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete event (admin only)
  Future<void> deleteEvent(String id) async {
    try {
      final response = await _dio.delete('/admin/events/$id');
      
      if (response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to delete event');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== DEPARTMENTS ENDPOINTS ====================

  /// Get all departments (public)
  Future<List<Map<String, dynamic>>> getDepartments() async {
    try {
      final response = await _dio.get('/departments');
      
      // Handle both formats: {success: true, data: []} or {data: []}
      if (response.data['data'] != null) {
        final List<dynamic> departments = response.data['data'] ?? [];
        return departments.cast<Map<String, dynamic>>();
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch departments');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get single department by ID (public)
  Future<Map<String, dynamic>> getDepartment(String id) async {
    try {
      final response = await _dio.get('/departments/$id');
      
      // Handle both formats: {success: true, data: {}} or {data: {}}
      if (response.data['data'] != null) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch department');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get clubs in a department (public)
  Future<List<Map<String, dynamic>>> getDepartmentClubs(String departmentId) async {
    try {
      final response = await _dio.get('/departments/$departmentId/clubs');
      
      // Handle both formats: {success: true, data: []} or {data: []}
      if (response.data['data'] != null) {
        final List<dynamic> clubs = response.data['data'] ?? [];
        return clubs.cast<Map<String, dynamic>>();
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch department clubs');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create department (admin only)
  Future<Map<String, dynamic>> createDepartment({
    required String code,
    required String name,
    String? description,
    String? logoUrl,
    String? iconName,
    String? colorHex,
  }) async {
    try {
      final response = await _dio.post('/admin/departments', data: {
        'code': code,
        'name': name,
        if (description != null) 'description': description,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (iconName != null) 'icon_name': iconName,
        if (colorHex != null) 'color_hex': colorHex,
      });
      
      // Handle both formats: {success: true, data: {}} or {data: {}}
      if (response.data['data'] != null) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to create department');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update department (admin only)
  Future<Map<String, dynamic>> updateDepartment({
    required String id,
    String? code,
    String? name,
    String? description,
    String? logoUrl,
    String? iconName,
    String? colorHex,
  }) async {
    try {
      final response = await _dio.put('/admin/departments/$id', data: {
        if (code != null) 'code': code,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (iconName != null) 'icon_name': iconName,
        if (colorHex != null) 'color_hex': colorHex,
      });
      
      // Handle both formats: {success: true, data: {}} or {data: {}}
      if (response.data['data'] != null) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to update department');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete department (admin only)
  Future<void> deleteDepartment(String id) async {
    try {
      final response = await _dio.delete('/admin/departments/$id');
      
      // Handle both formats: {success: true, message: '...'} or {message: '...'}
      if (response.data['error'] != null) {
        throw Exception(response.data['error']);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== CLUBS ENDPOINTS ====================

  /// Get all clubs (public)
  Future<List<Map<String, dynamic>>> getClubs() async {
    try {
      final response = await _dio.get('/clubs');
      
      // Handle both formats: {success: true, data: []} or {data: []}
      if (response.data['data'] != null) {
        final List<dynamic> clubs = response.data['data'] ?? [];
        return clubs.cast<Map<String, dynamic>>();
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch clubs');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get single club by ID (public)
  Future<Map<String, dynamic>> getClub(String id) async {
    try {
      final response = await _dio.get('/clubs/$id');
      
      // Handle both formats: {success: true, data: {}} or {data: {}}
      if (response.data['data'] != null) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch club');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create club (admin only)
  Future<Map<String, dynamic>> createClub({
    String? departmentId,
    required String name,
    String? tagline,
    String? description,
    String? logoUrl,
    String? primaryColor,
    String? secondaryColor,
    String? email,
    String? phone,
    String? website,
    Map<String, dynamic>? socialLinks,
  }) async {
    try {
      final response = await _dio.post('/admin/clubs', data: {
        if (departmentId != null) 'department_id': departmentId,
        'name': name,
        if (tagline != null) 'tagline': tagline,
        if (description != null) 'description': description,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (primaryColor != null) 'primary_color': primaryColor,
        if (secondaryColor != null) 'secondary_color': secondaryColor,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (website != null) 'website': website,
        'social_links': socialLinks ?? {},
      });
      
      // Handle both formats: {success: true, data: {}} or {data: {}}
      if (response.data['data'] != null) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to create club');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update club (admin only)
  Future<Map<String, dynamic>> updateClub({
    required String id,
    String? departmentId,
    String? name,
    String? tagline,
    String? description,
    String? logoUrl,
    String? primaryColor,
    String? secondaryColor,
    String? email,
    String? phone,
    String? website,
    Map<String, dynamic>? socialLinks,
  }) async {
    try {
      final response = await _dio.put('/admin/clubs/$id', data: {
        if (departmentId != null) 'department_id': departmentId,
        if (name != null) 'name': name,
        if (tagline != null) 'tagline': tagline,
        if (description != null) 'description': description,
        if (logoUrl != null) 'logo_url': logoUrl,
        if (primaryColor != null) 'primary_color': primaryColor,
        if (secondaryColor != null) 'secondary_color': secondaryColor,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (website != null) 'website': website,
        if (socialLinks != null) 'social_links': socialLinks,
      });
      
      // Handle both formats: {success: true, data: {}} or {data: {}}
      if (response.data['data'] != null) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to update club');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete club (admin only)
  Future<void> deleteClub(String id) async {
    try {
      final response = await _dio.delete('/admin/clubs/$id');
      
      // Handle both formats: {success: true, message: '...'} or {message: '...'}
      if (response.data['error'] != null) {
        throw Exception(response.data['error']);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get club members (public)
  Future<List<Map<String, dynamic>>> getClubMembers(String clubId) async {
    try {
      final response = await _dio.get('/clubs/$clubId/members');
      
      if (response.data['success'] == true) {
        final List<dynamic> members = response.data['data'] ?? [];
        return members.cast<Map<String, dynamic>>();
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch club members');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get club events (public)
  Future<List<Map<String, dynamic>>> getClubEvents(String clubId) async {
    try {
      final response = await _dio.get('/clubs/$clubId/events');
      
      if (response.data['success'] == true) {
        final List<dynamic> events = response.data['data'] ?? [];
        return events.cast<Map<String, dynamic>>();
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch club events');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== CLUB MEMBERS ENDPOINTS ====================

  /// Add member to club (authenticated)
  Future<Map<String, dynamic>> addClubMember({
    required String clubId,
    required String userId,
    String? role,
    String? position,
  }) async {
    try {
      final response = await _dio.post('/clubs/$clubId/members', data: {
        'user_id': userId,
        if (role != null) 'role': role,
        if (position != null) 'position': position,
      });
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to add club member');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update club member (authenticated)
  Future<Map<String, dynamic>> updateClubMember({
    required String clubId,
    required String userId,
    String? role,
    String? position,
  }) async {
    try {
      final response = await _dio.put('/clubs/$clubId/members/$userId', data: {
        if (role != null) 'role': role,
        if (position != null) 'position': position,
      });
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to update club member');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Remove member from club (authenticated)
  Future<void> removeClubMember({
    required String clubId,
    required String userId,
  }) async {
    try {
      final response = await _dio.delete('/clubs/$clubId/members/$userId');
      
      if (response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to remove club member');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== CLUB ANNOUNCEMENTS ENDPOINTS ====================

  /// Get club announcements (public)
  Future<List<Map<String, dynamic>>> getClubAnnouncements(String clubId) async {
    try {
      final response = await _dio.get('/clubs/$clubId/announcements');
      
      if (response.data['success'] == true) {
        final List<dynamic> announcements = response.data['data'] ?? [];
        return announcements.cast<Map<String, dynamic>>();
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch announcements');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create club announcement (authenticated)
  Future<Map<String, dynamic>> createClubAnnouncement({
    required String clubId,
    required String title,
    required String content,
    String? priority,
    bool? isPinned,
  }) async {
    try {
      final response = await _dio.post('/clubs/$clubId/announcements', data: {
        'title': title,
        'content': content,
        if (priority != null) 'priority': priority,
        if (isPinned != null) 'is_pinned': isPinned,
      });
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to create announcement');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update club announcement (authenticated)
  Future<Map<String, dynamic>> updateClubAnnouncement({
    required String clubId,
    required String announcementId,
    String? title,
    String? content,
    String? priority,
    bool? isPinned,
  }) async {
    try {
      final response = await _dio.put('/clubs/$clubId/announcements/$announcementId', data: {
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (priority != null) 'priority': priority,
        if (isPinned != null) 'is_pinned': isPinned,
      });
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to update announcement');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete club announcement (authenticated)
  Future<void> deleteClubAnnouncement({
    required String clubId,
    required String announcementId,
  }) async {
    try {
      final response = await _dio.delete('/clubs/$clubId/announcements/$announcementId');
      
      if (response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to delete announcement');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== CLUB AWARDS ENDPOINTS ====================

  /// Get club awards (public)
  Future<List<Map<String, dynamic>>> getClubAwards(String clubId) async {
    try {
      final response = await _dio.get('/clubs/$clubId/awards');
      
      if (response.data['success'] == true) {
        final List<dynamic> awards = response.data['data'] ?? [];
        return awards.cast<Map<String, dynamic>>();
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch awards');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create club award (authenticated)
  Future<Map<String, dynamic>> createClubAward({
    required String clubId,
    required String awardName,
    String? description,
    String? position,
    double? prizeAmount,
    String? eventName,
    DateTime? awardedDate,
    String? certificateUrl,
  }) async {
    try {
      final response = await _dio.post('/clubs/$clubId/awards', data: {
        'award_name': awardName,
        if (description != null) 'description': description,
        if (position != null) 'position': position,
        if (prizeAmount != null) 'prize_amount': prizeAmount,
        if (eventName != null) 'event_name': eventName,
        if (awardedDate != null) 'awarded_date': awardedDate.toIso8601String(),
        if (certificateUrl != null) 'certificate_url': certificateUrl,
      });
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to create award');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== SCHEDULES ENDPOINTS ====================

  /// Get schedules for a specific date (public - returns official schedules + personal if authenticated)
  Future<List<Map<String, dynamic>>> getSchedules(DateTime date) async {
    try {
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await _dio.get('/schedules', queryParameters: {'date': dateStr});
      
      if (response.data['success'] == true) {
        final List<dynamic> schedules = response.data['data'] ?? [];
        return schedules.cast<Map<String, dynamic>>();
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch schedules');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get single schedule by ID
  Future<Map<String, dynamic>> getSchedule(String id) async {
    try {
      final response = await _dio.get('/schedules/$id');
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to fetch schedule');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create schedule (authenticated - admin can create official, students create personal)
  Future<Map<String, dynamic>> createSchedule({
    required String title,
    String? description,
    required DateTime scheduleDate,
    required String startTime,
    String? endTime,
    String? location,
    String scheduleType = 'personal', // 'official' or 'personal'
  }) async {
    try {
      final dateStr = '${scheduleDate.year}-${scheduleDate.month.toString().padLeft(2, '0')}-${scheduleDate.day.toString().padLeft(2, '0')}';
      final response = await _dio.post('/schedules', data: {
        'title': title,
        if (description != null) 'description': description,
        'schedule_date': dateStr,
        'start_time': startTime,
        if (endTime != null) 'end_time': endTime,
        if (location != null) 'location': location,
        'schedule_type': scheduleType,
      });
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to create schedule');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update schedule (authenticated - admin can update any, students can only update their personal schedules)
  Future<Map<String, dynamic>> updateSchedule({
    required String id,
    String? title,
    String? description,
    DateTime? scheduleDate,
    String? startTime,
    String? endTime,
    String? location,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (scheduleDate != null) {
        data['schedule_date'] = '${scheduleDate.year}-${scheduleDate.month.toString().padLeft(2, '0')}-${scheduleDate.day.toString().padLeft(2, '0')}';
      }
      if (startTime != null) data['start_time'] = startTime;
      if (endTime != null) data['end_time'] = endTime;
      if (location != null) data['location'] = location;
      
      final response = await _dio.put('/schedules/$id', data: data);
      
      if (response.data['success'] == true) {
        return response.data['data'];
      }
      
      throw Exception(response.data['error'] ?? 'Failed to update schedule');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete schedule (authenticated - admin can delete any, students can only delete their personal schedules)
  Future<void> deleteSchedule(String id) async {
    try {
      final response = await _dio.delete('/schedules/$id');
      
      if (response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to delete schedule');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== ERROR HANDLING ====================

  String _handleError(DioException error) {
    if (error.response != null) {
      // Server responded with an error
      final data = error.response!.data;
      if (data is Map && data['error'] != null) {
        return data['error'].toString();
      }
      return 'Server error: ${error.response!.statusCode}';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server. Make sure the backend is running.';
    }
    return 'An unexpected error occurred: ${error.message}';
  }
}

