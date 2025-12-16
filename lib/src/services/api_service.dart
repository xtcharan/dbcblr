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
