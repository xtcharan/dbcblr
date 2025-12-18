import 'package:dio/dio.dart';
import '../models/event.dart';
import 'payment_service.dart';

/// API Service for payment-related operations
class PaymentApiService {
  final Dio _dio;
  final String _baseUrl;

  PaymentApiService({required Dio dio, required String baseUrl})
      : _dio = dio,
        _baseUrl = baseUrl;

  /// Create a Razorpay order for an event
  /// Returns order details needed for checkout
  Future<CreateOrderResponse> createOrder(String eventId, String authToken) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/v1/payments/create-order',
        data: {'event_id': eventId},
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      if (response.data['success'] == true) {
        return CreateOrderResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to create order');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['error'] ?? 'Network error');
    }
  }

  /// Verify payment after successful Razorpay checkout
  Future<bool> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required String eventId,
    required String authToken,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/v1/payments/verify',
        data: {
          'razorpay_order_id': razorpayOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
          'event_id': eventId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      return response.data['success'] == true;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['error'] ?? 'Payment verification failed');
    }
  }

  /// Check if user has already paid for an event
  Future<PaymentStatusResponse> getPaymentStatus(String eventId, String authToken) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/v1/payments/status/$eventId',
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      if (response.data['success'] == true) {
        return PaymentStatusResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['error'] ?? 'Failed to get payment status');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['error'] ?? 'Network error');
    }
  }
}
