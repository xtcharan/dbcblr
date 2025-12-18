import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Response from backend when creating a Razorpay order
class CreateOrderResponse {
  final String orderId;
  final int amount; // Amount in paise
  final String currency;
  final String keyId;
  final String eventId;

  CreateOrderResponse({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.keyId,
    required this.eventId,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      orderId: json['order_id'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      keyId: json['key_id'] as String,
      eventId: json['event_id'] as String,
    );
  }
}

/// Payment status response from backend
class PaymentStatusResponse {
  final bool hasPaid;
  final String? paymentId;
  final String? status;

  PaymentStatusResponse({
    required this.hasPaid,
    this.paymentId,
    this.status,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      hasPaid: json['has_paid'] as bool,
      paymentId: json['payment_id'] as String?,
      status: json['status'] as String?,
    );
  }
}

/// Service for handling Razorpay payments
class PaymentService {
  Razorpay? _razorpay;
  String? _keyId;

  // Callbacks
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onError;
  Function(ExternalWalletResponse)? onExternalWallet;

  bool get isInitialized => _razorpay != null;

  /// Initialize Razorpay with your Key ID
  void initialize(String keyId) {
    _keyId = keyId;
    _razorpay = Razorpay(keyId);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Open Razorpay Checkout with the given order details
  void openCheckout({
    required String orderId,
    required int amountInPaise,
    required String currency,
    required String name,
    required String description,
    required String prefillContact,
    required String prefillEmail,
    String? imageUrl,
  }) {
    if (_razorpay == null || _keyId == null) {
      throw Exception('PaymentService not initialized. Call initialize() first.');
    }

    var options = <String, dynamic>{
      'key': _keyId,
      'amount': amountInPaise,
      'currency': currency,
      'name': name,
      'description': description,
      'order_id': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': prefillContact,
        'email': prefillEmail,
      },
      'theme': {'color': '#4F46E5'},
    };

    if (imageUrl != null) {
      options['image'] = imageUrl;
    }

    _razorpay!.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onError?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onExternalWallet?.call(response);
  }

  /// Clear all event listeners and dispose
  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
    _keyId = null;
    onSuccess = null;
    onError = null;
    onExternalWallet = null;
  }
}
