# Flutter App Backend Integration Guide

## ✅ Completed Setup

1. **Dependencies Added** (`pubspec.yaml`):
   - `dio: ^5.4.0` - HTTP client for API calls
   - `flutter_secure_storage: ^9.0.0` - Secure token storage

2. **API Service Created** (`lib/src/services/api_service.dart`):
   - Authentication (login, register, logout)
   - Event management (CRUD operations)
   - Automatic JWT token handling
   - Error handling

3. **Event Model Updated** (`lib/src/shared/models/event.dart`):
   - Added `fromJson()` for backend responses
   - Added `toJson()` for API requests

---

## 🚀 How to Integrate Events Page with Backend

### Step 1: Update Events Page to Use API

**File:** `lib/src/features/events/events_page.dart`

Replace the hardcoded `_events` list with API calls:

```dart
import '../../services/api_service.dart';

class _EventsPageState extends State<EventsPage> {
  final ApiService _apiService = ApiService();
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadEvents(); // Load events from backend
  }
  
  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final eventsData = await _apiService.getEvents();
      setState(() {
        _events = eventsData.map((json) => Event.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  // ... rest of the code
}
```

### Step 2: Update Create Event Function

Modify `_navigateToCreateEvent` to save to backend:

```dart
void _navigateToCreateEvent([Event? eventToEdit]) async {
  final result = await Navigator.of(context).push<Event>(
    MaterialPageRoute(
      builder: (context) => CreateEventPage(event: eventToEdit),
      fullscreenDialog: true,
    ),
  );
  
  if (result != null) {
    try {
      if (eventToEdit != null) {
        // Update existing event via API
        await _apiService.updateEvent(
          id: result.id,
          title: result.title,
          description: result.description,
          startDate: result.startDate,
          endDate: result.endDate,
          location: result.location,
          category: result.category,
          imageUrl: result.eventImage,
          maxCapacity: result.availableSeats,
        );
      } else {
        // Create new event via API
        await _apiService.createEvent(
          title: result.title,
          description: result.description,
          startDate: result.startDate,
          endDate: result.endDate,
          location: result.location,
          category: result.category,
          imageUrl: result.eventImage,
          maxCapacity: result.availableSeats,
        );
      }
      
      // Reload events from backend
      await _loadEvents();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(eventToEdit != null ? 'Event updated!' : 'Event created!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }
}
```

### Step 3: Update Delete Function

Modify `_deleteEvent` to delete from backend:

```dart
void _deleteEvent(Event event) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
  
  if (confirmed == true) {
    try {
      await _apiService.deleteEvent(event.id);
      await _loadEvents(); // Reload from backend
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }
}
```

###  Step 4: Add Loading & Error UI

Update the `build` method to show loading/error states:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          // ... header and search bar ...
          
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red),
                            SizedBox(height: 16),
                            Text('Error loading events'),
                            Text(_error!, style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadEvents,
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        // ... existing event list UI ...
                      ),
          ),
        ],
      ),
    ),
  );
}
```

---

## 📝 Testing the Integration

### 1. Start the Backend
```bash
cd d:\App\backend\docker
docker-compose ps  # Check if running
```

### 2. Run the Flutter App
```bash
cd d:\App\dbcblr
flutter run
```

### 3. Test Flow
1. **View Events**: App should load events from backend
2. **Create Event**: Tap "Create Event", fill form, save
3. **Verify**: Check if event appears (it's saved to database)
4. **Edit Event**: Long press event card, edit details
5. **Delete Event**: Long press event card, delete

---

## 🔐 Adding Authentication (Optional)

### Create Login Page

```dart
// lib/src/features/auth/login_page.dart

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _apiService = ApiService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  Future<void> _login() async {
   try {
      final response = await _apiService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      // Navigate to home page
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }
  
  // ... build method with email/password fields ...
}
```

###  Check Auth on App Start

```dart
// lib/src/app.dart or main.dart

Future<bool> checkAuth() async {
  final apiService = ApiService();
  return await apiService.isLoggedIn();
}

// In your app initialization:
final isLoggedIn = await checkAuth();
initialRoute: isLoggedIn ? '/home' : '/login',
```

---

## 🌐 Important Notes

### Backend URL Configuration

**For Development (Local):**
- Android Emulator: Use `http://10.0.2.2:8080/api/v1`
- iOS Simulator: Use `http://localhost:8080/api/v1`
- Physical Device: Use `http://YOUR_COMPUTER_IP:8080/api/v1`

Update in `lib/src/services/api_service.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:8080/api/v1'; // For Android
```

**For Production:**
```dart
static const String baseUrl = 'https://your-backend-url.com/api/v1';
```

### Admin Access

Admin credentials (from `.env`):
- Email: `admin@college.edu`
- Password: `admin123`

Only admin users can create/edit/delete events.

---

## 🐛 Troubleshooting

### "Connection refused" or "Cannot connect to server"
- Make sure backend is running: `docker-compose ps` 
- Check backend URL in `api_service.dart`
- For Android emulator, use `10.0.2.2` instead of `localhost`

### "401 Unauthorized" errors
- User needs to login first
- Token might be expired - implement token refresh

### Events not appearing
- Check backend logs: `docker-compose logs api`
- Verify events exist: `curl http://localhost:8080/api/v1/events`

---

## ✅ Next Steps

1. Update events_page.dart with API integration (use code above)
2. Test create/edit/delete events
3. Add authentication (login/register pages)
4. Update other pages (clubs, announcements) similarly
5. Deploy backend to Google Cloud
6. Update baseUrl to production URL

**Your backend is ready and waiting for the Flutter app to connect!** 🚀
