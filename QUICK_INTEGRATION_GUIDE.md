# 🚀 Quick Integration Guide - Clubs & Departments

## Add to Your App in 3 Steps

### Step 1: Add Navigation Item

Add a navigation option in your main menu (drawer, bottom nav, or home page):

```dart
// Example: In your drawer
ListTile(
  leading: const Icon(Icons.school),
  title: const Text('Departments & Clubs'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DepartmentsListPage(),
      ),
    );
  },
),
```

Or create a card on your home page:

```dart
// Example: On home page
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DepartmentsListPage(),
      ),
    );
  },
  child: Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.school, size: 48, color: Colors.blue),
          const SizedBox(height: 8),
          const Text('Departments & Clubs'),
        ],
      ),
    ),
  ),
),
```

### Step 2: Import the New Pages

Add this import wherever you need to navigate:

```dart
import 'package:your_app/src/features/clubs/pages/departments_list_page.dart';
```

### Step 3: Test the Integration

1. Start your backend:
```bash
cd backend/docker
docker-compose up
```

2. Run your Flutter app:
```bash
flutter run
```

3. Navigate to "Departments & Clubs" and explore!

---

## Admin Features

To enable admin features (create departments/clubs), add floating action buttons:

```dart
// On DepartmentsListPage
class DepartmentsListPage extends StatefulWidget {
  // ... existing code
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: // ... existing body
      // Add FAB for admins
      floatingActionButton: _isAdmin ? FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateDepartmentPage(),
            ),
          );
          if (result == true) {
            _loadDepartments(); // Refresh list
          }
        },
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}
```

Check if user is admin:
```dart
bool get _isAdmin {
  // Check user role from your auth state
  // Example: return Provider.of<AuthProvider>(context).isAdmin;
  return true; // Temporary: Allow all users for testing
}
```

---

## Sample Data for Testing

Use these API calls to create sample data (requires admin token):

### Create BCA Department
```bash
POST http://localhost:8080/api/v1/admin/departments
Authorization: Bearer YOUR_ADMIN_TOKEN

{
  "code": "BCA",
  "name": "Bachelor of Computer Applications",
  "description": "Learn programming and software development",
  "icon_name": "computer",
  "color_hex": "#4F46E5"
}
```

### Create BITBLAZE Club
```bash
POST http://localhost:8080/api/v1/admin/clubs
Authorization: Bearer YOUR_ADMIN_TOKEN

{
  "department_id": "DEPARTMENT_UUID_FROM_ABOVE",
  "name": "BITBLAZE",
  "tagline": "Innovation through technology",
  "description": "A tech club focused on AI and development",
  "primary_color": "#4F46E5",
  "secondary_color": "#818CF8",
  "email": "bitblaze@college.edu",
  "social_links": {}
}
```

---

## Customization Options

### Change Colors

Edit department/club colors in the create forms or update via API:

```dart
// Custom color palette
const departmentColors = [
  '#4F46E5', // Indigo
  '#059669', // Green
  '#DC2626', // Red
  '#D97706', // Orange
  '#7C3AED', // Purple
];
```

### Add Icons

Available icon names (map to Flutter Icons):
- `computer` → Icons.computer
- `business` → Icons.business  
- `account_balance` → Icons.account_balance
- `science` → Icons.science
- `art` → Icons.palette
- `book` → Icons.book

Add more in `_getIconData()` method in `departments_list_page.dart`

### Customize Priority Colors

In `club_detail_page.dart`, `_buildPriorityBadge()`:

```dart
Color color;
switch (priority.toLowerCase()) {
  case 'urgent':
    color = Colors.red;      // Change this
  case 'high':
    color = Colors.orange;   // Or this
  case 'normal':
    color = Colors.blue;     // Or this
  default:
    color = Colors.grey;
}
```

---

## Troubleshooting

### "Cannot connect to server"
- Make sure backend is running: `docker-compose up`
- Check API URL in `api_service.dart`: `http://10.0.2.2:8080/api/v1`
- For iOS simulator, use: `http://localhost:8080/api/v1`

### "No departments found"
- Create sample departments using admin API calls
- Check backend logs: `docker-compose logs api`

### Colors not showing
- Ensure color hex format is correct: `#RRGGBB`
- Check `_parseColor()` method is working

### Images not loading
- Verify image URLs are accessible
- Check network permissions in `AndroidManifest.xml` and `Info.plist`

---

## Pro Tips

1. **Fast Development**: Use hot reload while designing UI
2. **Sample Data**: Create 3-4 departments with clubs for testing
3. **Admin Login**: Login as admin to test create/edit features
4. **Error Testing**: Turn off backend to test error states
5. **Empty States**: Test with no data to see empty state UI

---

That's it! Your app now has a complete clubs and departments feature. Enjoy! 🎉
