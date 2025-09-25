import 'package:flutter/material.dart';

enum EventType {
  workshop,
  competition,
  seminar,
  hackathon,
  cultural,
  social,
  networking,
  other,
}

enum EventScope {
  college,
  interCollege,
  national,
  international,
}

class ClubEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime endDate;
  final String time;
  final String location;
  final EventType type;
  final EventScope scope;
  final String? prizePool;
  final int maxParticipants;
  final int currentParticipants;
  final double? fees;
  final String? requirements;
  final String contactInfo;
  final List<String> highlights;
  final bool isRegistrationOpen;
  final String? registrationLink;

  const ClubEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.endDate,
    required this.time,
    required this.location,
    required this.type,
    required this.scope,
    this.prizePool,
    required this.maxParticipants,
    required this.currentParticipants,
    this.fees,
    this.requirements,
    required this.contactInfo,
    required this.highlights,
    required this.isRegistrationOpen,
    this.registrationLink,
  });

  bool get isUpcoming => date.isAfter(DateTime.now());
  bool get isToday => DateUtils.isSameDay(date, DateTime.now());
  bool get isFull => currentParticipants >= maxParticipants;
  
  String get spotsRemaining => '${maxParticipants - currentParticipants}/$maxParticipants';
  String get eventTypeDisplay => type.toString().split('.').last.toUpperCase();
  String get scopeDisplay => scope.toString().split('.').last.replaceAll('C', ' C');
}

class ClubLeader {
  final String name;
  final String role;
  final String? email;
  final String? phone;
  final String? avatar;

  const ClubLeader({
    required this.name,
    required this.role,
    this.email,
    this.phone,
    this.avatar,
  });
}

class Club {
  final String id;
  final String name;
  final String shortName;
  final String departmentCode;
  final String tagline;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final int memberCount;
  final double rating;
  final List<ClubEvent> events;
  final List<String> recentActivities;
  final List<ClubLeader> leadership;
  final List<String> achievements;
  final String? socialMedia;
  final String? email;
  final DateTime establishedDate;
  final List<String> specializations;

  const Club({
    required this.id,
    required this.name,
    required this.shortName,
    required this.departmentCode,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.memberCount,
    required this.rating,
    required this.events,
    required this.recentActivities,
    required this.leadership,
    required this.achievements,
    this.socialMedia,
    this.email,
    required this.establishedDate,
    required this.specializations,
  });

  List<ClubEvent> get upcomingEvents {
    return events.where((event) => event.isUpcoming).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  ClubEvent? get nextEvent {
    final upcoming = upcomingEvents;
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  int get totalEvents => events.length;
  int get upcomingEventsCount => upcomingEvents.length;
  
  ClubLeader? get president => leadership.where((leader) => 
      leader.role.toLowerCase().contains('president')).firstOrNull;
}