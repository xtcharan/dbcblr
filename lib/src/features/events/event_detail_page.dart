import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../shared/models/event.dart';
import '../../shared/utils/theme_colors.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isDescriptionExpanded = false;
  bool _isLoading = false;
  bool _hasPaid = false;
  
  late Razorpay _razorpay;
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _currentOrderId;
  
  // API base URL - adjust for your environment
  static const String _baseUrl = 'http://10.0.2.2:8080'; // Android emulator localhost

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _checkPaymentStatus();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<void> _checkPaymentStatus() async {
    if (!widget.event.isPaidEvent) return;
    
    final token = await _getAuthToken();
    if (token == null) return;
    
    try {
      final response = await _dio.get(
        '$_baseUrl/api/v1/payments/status/${widget.event.id}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data['success'] == true) {
        setState(() {
          _hasPaid = response.data['data']['has_paid'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('Error checking payment status: $e');
    }
  }

  Future<void> _handleEnroll() async {
    // If free event or already paid, just enroll
    if (!widget.event.isPaidEvent || _hasPaid) {
      _showEnrollSuccess();
      return;
    }
    
    // For paid events, start payment flow
    await _initiatePayment();
  }

  Future<void> _initiatePayment() async {
    setState(() => _isLoading = true);
    
    final token = await _getAuthToken();
    if (token == null) {
      Fluttertoast.showToast(msg: 'Please login to continue');
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Create order on backend
      final response = await _dio.post(
        '$_baseUrl/api/v1/payments/create-order',
        data: {'event_id': widget.event.id},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success'] == true) {
        final orderData = response.data['data'];
        _currentOrderId = orderData['order_id'];
        
        // Open Razorpay checkout
        var options = {
          'key': orderData['key_id'],
          'amount': orderData['amount'],
          'currency': orderData['currency'],
          'order_id': orderData['order_id'],
          'name': 'Event Registration',
          'description': widget.event.title,
          'retry': {'enabled': true, 'max_count': 1},
          'send_sms_hash': true,
          'theme': {'color': '#4F46E5'},
        };
        
        _razorpay.open(options);
      } else {
        Fluttertoast.showToast(msg: response.data['error'] ?? 'Failed to create order');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Payment initialization failed');
      debugPrint('Payment error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final token = await _getAuthToken();
    if (token == null) return;

    try {
      // Verify payment on backend
      final verifyResponse = await _dio.post(
        '$_baseUrl/api/v1/payments/verify',
        data: {
          'razorpay_order_id': response.orderId,
          'razorpay_payment_id': response.paymentId,
          'razorpay_signature': response.signature,
          'event_id': widget.event.id,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (verifyResponse.data['success'] == true) {
        setState(() => _hasPaid = true);
        _showEnrollSuccess();
      } else {
        Fluttertoast.showToast(msg: 'Payment verification failed');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Verification failed');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: 'Payment failed: ${response.message ?? 'Unknown error'}',
      backgroundColor: Colors.red,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'External Wallet: ${response.walletName}');
  }

  void _showEnrollSuccess() {
    Fluttertoast.showToast(
      msg: 'Successfully enrolled in ${widget.event.title}!',
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_LONG,
    );
  }
  
  // Sample guest data
  final List<Map<String, dynamic>> _guestData = [
    {
      'name': 'John Doe',
      'designation': 'CEO at TechCorp',
      'initials': 'JD',
      'color': Colors.blue.shade100,
      'textColor': Colors.blue.shade700,
    },
    {
      'name': 'Sarah Wilson',
      'designation': 'CTO at DevCorp',
      'initials': 'SW',
      'color': Colors.purple.shade100,
      'textColor': Colors.purple.shade700,
    },
    {
      'name': 'Mike Johnson',
      'designation': 'Designer',
      'initials': 'MJ',
      'color': Colors.green.shade100,
      'textColor': Colors.green.shade700,
    },
    {
      'name': 'Lisa Chen',
      'designation': 'Product Manager',
      'initials': 'LC',
      'color': Colors.orange.shade100,
      'textColor': Colors.orange.shade700,
    },
    {
      'name': 'David Park',
      'designation': 'Engineer',
      'initials': 'DP',
      'color': Colors.red.shade100,
      'textColor': Colors.red.shade700,
    },
    {
      'name': 'Emma Davis',
      'designation': 'Marketing',
      'initials': 'ED',
      'color': Colors.teal.shade100,
      'textColor': Colors.teal.shade700,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dateTimeFormatter = DateFormat('EEEE, MMM dd, yyyy • HH:mm');
    
    final fullDateTime = dateTimeFormatter.format(widget.event.startDate);

    return Scaffold(
      backgroundColor: ThemeColors.background(context),
      body: CustomScrollView(
        slivers: [
          // App Bar with Event Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: ThemeColors.surface(context),
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Event Image
                  widget.event.eventImage != null
                      ? Image.network(
                          widget.event.eventImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: ThemeColors.surface(context),
                              child: Icon(
                                Icons.event,
                                size: 80,
                                color: ThemeColors.iconSecondary(context),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: ThemeColors.surface(context),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ThemeColors.primary,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: ThemeColors.surface(context),
                          child: Icon(
                            Icons.event,
                            size: 80,
                            color: ThemeColors.iconSecondary(context),
                          ),
                        ),
                  
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    widget.event.title,
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.text(context),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Available seats
                  Text(
                    widget.event.availableSeats != null 
                        ? '${widget.event.availableSeats} seats available' 
                        : 'Limited seats available',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: ThemeColors.textSecondary(context),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date and Time
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: ThemeColors.icon(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        fullDateTime,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: ThemeColors.text(context),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: ThemeColors.icon(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.event.location,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: ThemeColors.text(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // About Event Section
                  Text(
                    'About Event',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.text(context),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    widget.event.description,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: ThemeColors.textSecondary(context),
                      height: 1.5,
                    ),
                    maxLines: _isDescriptionExpanded ? null : 2,
                    overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Read more link
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDescriptionExpanded = !_isDescriptionExpanded;
                      });
                    },
                    child: Text(
                      _isDescriptionExpanded ? 'read less...' : 'read more...',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: ThemeColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // iPhone-style Guest Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeColors.surface(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ThemeColors.cardBorder(context),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Guest Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Guest',
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: ThemeColors.text(context),
                              ),
                            ),
                            Text(
                              'view all',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: ThemeColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Horizontal Scrollable Guest Profiles
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _guestData.length,
                            padding: const EdgeInsets.only(right: 8),
                            itemBuilder: (context, index) {
                              final guest = _guestData[index];
                              return Container(
                                width: 80,
                                margin: EdgeInsets.only(right: index < _guestData.length - 1 ? 16 : 0),
                                child: Column(
                                  children: [
                                    // Profile Picture
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: guest['color'] as Color,
                                      child: Text(
                                        guest['initials'] as String,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: guest['textColor'] as Color,
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 8),
                                    
                                    // Guest Name
                                    Text(
                                      guest['name'] as String,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: ThemeColors.text(context),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    // Guest Designation
                                    Text(
                                      guest['designation'] as String,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 10,
                                        color: ThemeColors.textSecondary(context),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Price display for paid events
                  if (widget.event.isPaidEvent) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Registration Fee',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.event.formattedPrice,
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Enroll Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _hasPaid ? Colors.green : const Color(0xFF446AEF),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (_hasPaid ? Colors.green : const Color(0xFF446AEF)).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: (_isLoading || _hasPaid) ? null : _handleEnroll,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              // Mini Profiles Section
                              if (!_isLoading) ...[
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                                      child: Text(
                                        'A',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(-6, 0),
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                                        child: Text(
                                          'B',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(-12, 0),
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                                        child: Text(
                                          '15+',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              
                              const Spacer(),
                              
                              // Button content based on state
                              if (_isLoading)
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              else if (_hasPaid)
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Enrolled ✓',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  widget.event.isPaidEvent 
                                      ? 'Pay ${widget.event.formattedPrice} >>>' 
                                      : 'enroll now >>>',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
