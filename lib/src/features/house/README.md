# House System

## Overview

The house system allows administrators to create and manage houses (like school houses) with members, announcements, and events.

## Admin Features

> **Note**: Only administrators can create houses. Regular users can only view houses and interact with announcements/events.

### Creating a House

Admins can create houses with:
- **Name** - House name (e.g., "Ruby Rhinos")
- **Logo** - Upload a custom logo image  
- **Color** - Pick a theme color for the house
- **Description** - Optional description

### Managing Roles

Admins define custom roles with member names:
- Use the **+** button to add roles
- Each role has a **Member Name** and **Role Title**
- Examples:
  - "Sarah Johnson" → "House Captain"
  - "Mike Chen" → "Vice Captain"
  - "Emma Davis" → "Sports Coordinator"

### Announcements

Admins can post announcements that:
- Are visible to all users
- Can receive likes and comments from members

### House Events

Admins can create house-specific events with:
- Date, time, and venue
- Maximum participants
- Registration deadline

## User Features

Regular users can:
- View all houses and their standings
- See house members and their roles
- Like and comment on announcements
- Enroll in house events

## API Endpoints

| Action | Endpoint | Auth |
|--------|----------|------|
| List houses | `GET /houses` | Public |
| Get house | `GET /houses/:id` | Public |
| Create house | `POST /admin/houses` | Admin |
| Add role | `POST /houses/:id/roles` | Auth |
| Like announcement | `POST /announcements/:id/like` | Auth |
| Add comment | `POST /announcements/:id/comments` | Auth |
