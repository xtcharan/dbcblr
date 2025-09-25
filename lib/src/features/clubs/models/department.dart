import 'package:flutter/material.dart';
import 'club.dart';

class Department {
  final String code;
  final String name;
  final String description;
  final Color primaryColor;
  final IconData icon;
  final List<Club> clubs;
  final int totalMembers;
  final int totalEvents;
  final double rating;

  const Department({
    required this.code,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.icon,
    required this.clubs,
    required this.totalMembers,
    required this.totalEvents,
    required this.rating,
  });

  // Calculate statistics
  int get activeClubs => clubs.length;
  
  List<ClubEvent> get upcomingEvents {
    List<ClubEvent> allEvents = [];
    for (var club in clubs) {
      allEvents.addAll(club.upcomingEvents);
    }
    allEvents.sort((a, b) => a.date.compareTo(b.date));
    return allEvents;
  }

  ClubEvent? get nextEvent {
    final upcoming = upcomingEvents;
    return upcoming.isNotEmpty ? upcoming.first : null;
  }
}