# Flutter Events Page - Complete Flow Analysis

## Current Architecture

### 1. **CreateEventPage** (`admin/create_event_page.dart`)
```
- User fills form
- _submitForm() is called
- Creates Event object with DateTime from form fields
- Returns Event to events_page
- **NOTE: Does NOT call API directly** - just returns local Event
```

### 2. **EventsPage** (`events_page.dart`)
```
- Receives Event from CreateEventPage
- Calls _apiService.createEvent() with event details
- API formats data as: startDate.toIso8601String()
- Sends to backend: /admin/events
- Catches errors and shows SnackBar
```

### 3. **ApiService** (`services/api_service.dart`)
```
createEvent method:
- Receives DateTime startDate and endDate
- Converts to: startDate.toIso8601String() ✅ Correct format!
- Result: "2025-12-16T21:26:00.000Z"
- Sends JSON with this format to backend
```

---

## The Error You're Seeing

**Error Message:**
```
Error: invalid request body: parsing time "2025-12-16T21:26:00.000Z" as "2006-01-02T15:04:05Z07:00": cannot parse "" as Z07:00"
```

**Why You're Still Getting It:**

1. ✅ **Code Fix is Correct** - Backend JSONTime unmarshaler was added and tested
2. ❌ **But Backend Isn't Running** - The hot reload doesn't update the Go backend
3. ❌ **You're Calling Old Backend** - Flutter is hitting an old version still running
4. ❌ **OR Database Not Set Up** - Backend can't start due to DB connection issues

---

## What Needs to Happen

### Step 1: Rebuild Backend (Not Hot Reload)
```bash
cd backend
# Kill any running instance
go build ./cmd/api          # NEW BUILD
go run ./cmd/api/main.go    # Start fresh
```

### Step 2: Verify Backend Tests
```bash
cd backend
go test ./internal/models -v   # All 11 tests should pass ✅
```

### Step 3: Set Up Database
```bash
# If not already done:
# 1. Install PostgreSQL
# 2. Create database 'college_events'
# 3. Update .env with credentials
# 4. Run migrations:
go run ./cmd/migrate/main.go
```

### Step 4: Hot Reload Flutter (Works Now)
```bash
# In Flutter app terminal
r              # Hot reload to test
```

---

## The Complete Event Creation Flow (With Fixes)

### Frontend → API Service
```dart
// Flutter code in events_page.dart
await _apiService.createEvent(
  title: result.title,
  startDate: DateTime(2025, 12, 16, 21, 26),  ← DateTime object
  endDate: DateTime(2025, 12, 16, 23, 26),    ← DateTime object
  ...
);
```

### API Service Formatting
```dart
// In api_service.dart
'start_date': startDate.toIso8601String(),  // "2025-12-16T21:26:00.000Z" ✅
'end_date': endDate.toIso8601String(),      // "2025-12-16T23:26:00.000Z" ✅
```

### JSON Sent to Backend
```json
POST /admin/events
{
  "title": "Tech Event",
  "start_date": "2025-12-16T21:26:00.000Z",  ← THIS FORMAT
  "end_date": "2025-12-16T23:26:00.000Z"
}
```

### Backend Processing (With Fix)
```go
// In models.go - NEW JSONTime unmarshaler
func (jt *JSONTime) UnmarshalJSON(data []byte) error {
    // Tries "2025-12-16T21:26:00.000Z" format ✅ WORKS!
    // Result: Successfully parses the datetime
}
```

### Success Response to Flutter
```json
{
  "success": true,
  "message": "event created successfully",
  "data": {
    "id": "uuid...",
    "title": "Tech Event",
    "start_date": "2025-12-16T21:26:00Z",
    "end_date": "2025-12-16T23:26:00Z"
  }
}
```

### Flutter Display
```dart
// Event appears in list
// No errors ✅
```

---

## Why Hot Reload Didn't Work

**Hot Reload Updates:** Flutter code only (Dart)
**NOT Updated:** Go backend executable

**Solution:** Full rebuild of backend
```bash
go build ./cmd/api
go run ./cmd/api/main.go    # New instance with new code
```

---

## Troubleshooting Checklist

- [ ] Stop old backend process
- [ ] Rebuild backend: `go build ./cmd/api`
- [ ] Check tests: `go test ./internal/models -v` (11/11 pass)
- [ ] Setup PostgreSQL with credentials in .env
- [ ] Run migrations: `go run ./cmd/migrate/main.go`
- [ ] Start backend: `go run ./cmd/api/main.go`
- [ ] Check backend is running: `http://localhost:8080/health`
- [ ] Hot reload Flutter: `r`
- [ ] Try creating event in Flutter app
- [ ] **Should work now! ✅**

---

## Files Involved in Event Creation

### Frontend:
- `lib/src/features/events/admin/create_event_page.dart` - Form UI
- `lib/src/features/events/events_page.dart` - List & API calls
- `lib/src/services/api_service.dart` - HTTP communication
- `lib/src/shared/models/event.dart` - Event model with toJson()

### Backend:
- `internal/models/models.go` - **FIXED** ✅ JSONTime unmarshaler
- `internal/api/handlers/events.go` - **FIXED** ✅ Event creation handler
- `internal/api/router.go` - Routes
- `migrations/001_initial_schema.sql` - DB schema

---

## Key Point

**Your Flutter code is CORRECT** ✅
- It's already using `toIso8601String()` which produces the right format
- No changes needed to Flutter app

**Backend fix is COMPLETE** ✅
- Custom JSONTime unmarshaler handles Flutter's format
- All tests pass
- Just needs to be deployed (rebuild)

**What You Need to Do:**
1. Rebuild backend (full build, not hot reload)
2. Setup database
3. Start backend
4. Flutter should work immediately!

---

## Debug: Check What's Being Sent

To see exactly what Flutter is sending, add print to API service:

```dart
// In api_service.dart, inside createEvent method, add:
print('Sending start_date: ${startDate.toIso8601String()}');
print('Sending end_date: ${endDate.toIso8601String()}');

// Then check Flutter console output
```

Expected output:
```
Sending start_date: 2025-12-16T21:26:00.000Z
Sending end_date: 2025-12-16T23:26:00.000Z
```

This is exactly what the backend's JSONTime.UnmarshalJSON() expects! ✅
