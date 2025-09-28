import 'package:flutter/material.dart';
import '../models/department.dart';
import '../models/club.dart';

class ClubsData {
  static List<Department> getDepartments() {
    return [
      _getBCADepartment(),
      _getBBADepartment(),
      _getBCOMDepartment(),
      _getBADepartment(),
      _getBSWDepartment(),
    ];
  }

  static Department _getBCADepartment() {
    final bitblazeEvents = [
      ClubEvent(
        id: 'bb_hack_2025',
        title: 'HACKATHON 2025',
        description: '48-hour coding marathon to build innovative solutions for real-world problems.',
        date: DateTime(2024, 9, 28),
        endDate: DateTime(2024, 9, 29),
        time: '6:00 PM - 6:00 PM',
        location: 'Computer Lab Block A & B',
        type: EventType.hackathon,
        scope: EventScope.interCollege,
        prizePool: '₹50,000',
        maxParticipants: 50,
        currentParticipants: 12,
        fees: 200,
        requirements: 'Team of 2-4 members, Laptop required',
        contactInfo: 'bitblaze@college.edu',
        highlights: ['Industry mentors', 'Prizes for top 3 teams', 'Free meals', 'Networking opportunities'],
        isRegistrationOpen: true,
        registrationLink: 'https://forms.college.edu/hackathon2025',
      ),
      ClubEvent(
        id: 'bb_ai_workshop',
        title: 'AI Workshop Series: Machine Learning Fundamentals',
        description: 'Learn the basics of machine learning and build your first ML model.',
        date: DateTime(2024, 10, 5),
        endDate: DateTime(2024, 10, 5),
        time: '2:00 PM - 5:00 PM',
        location: 'Seminar Hall',
        type: EventType.workshop,
        scope: EventScope.college,
        maxParticipants: 60,
        currentParticipants: 45,
        fees: 50,
        requirements: 'Basic Python knowledge',
        contactInfo: 'workshops@bitblaze.club',
        highlights: ['Hands-on coding', 'Industry expert speaker', 'Certificate provided'],
        isRegistrationOpen: true,
      ),
      ClubEvent(
        id: 'bb_coding_comp',
        title: 'Monthly Coding Challenge',
        description: 'Test your algorithmic thinking and problem-solving skills.',
        date: DateTime(2024, 10, 12),
        endDate: DateTime(2024, 10, 12),
        time: '10:00 AM - 1:00 PM',
        location: 'Computer Lab C',
        type: EventType.competition,
        scope: EventScope.college,
        prizePool: '₹5,000',
        maxParticipants: 40,
        currentParticipants: 28,
        contactInfo: 'contests@bitblaze.club',
        highlights: ['Cash prizes', 'Ranking system', 'Mock interview experience'],
        isRegistrationOpen: true,
      ),
    ];


    final bitblaze = Club(
      id: 'bitblaze',
      name: 'BIT BLAZE',
      shortName: 'BitBlaze',
      departmentCode: 'BCA',
      tagline: 'Innovation Through Code',
      description: 'BitBlaze is the premier coding club of BCA department, fostering innovation and technical excellence among students.',
      icon: Icons.computer,
      primaryColor: Colors.indigo,
      secondaryColor: Colors.indigo.shade100,
      memberCount: 125,
      rating: 4.8,
      events: bitblazeEvents,
      recentActivities: [
        'Code Review Session - Sep 20',
        'Flutter Workshop - Sep 18', 
        'Tech Talk: Cloud Computing - Sep 15',
        'Project Showcase - Sep 12',
        'Git & GitHub Masterclass - Sep 8'
      ],
      leadership: [
        const ClubLeader(name: 'Arjun Sharma', role: 'President', email: 'president@bitblaze.club'),
        const ClubLeader(name: 'Priya Patel', role: 'Vice President', email: 'vp@bitblaze.club'),
        const ClubLeader(name: 'Rohit Kumar', role: 'Tech Lead', email: 'tech@bitblaze.club'),
        const ClubLeader(name: 'Sneha Reddy', role: 'Event Coordinator', email: 'events@bitblaze.club'),
      ],
      achievements: [
        'Won Inter-College Hackathon 2024',
        'Best Technical Club Award 2023',
        '450+ Projects Completed',
        '95% Placement Rate for Members'
      ],
      email: 'bitblaze@college.edu',
      establishedDate: DateTime(2018, 8, 15),
      specializations: ['Web Development', 'Mobile Apps', 'AI/ML', 'Competitive Programming'],
    );



    return Department(
      code: 'BCA',
      name: 'Bachelor of Computer Applications',
      description: 'Department of Computer Applications focusing on software development, programming, and IT solutions.',
      primaryColor: Colors.indigo,
      icon: Icons.computer,
      clubs: [bitblaze], // Only main club per department
      totalMembers: 281,
      totalEvents: 24,
      rating: 4.7,
    );
  }

  static Department _getBBADepartment() {
    final synergyEvents = [
      ClubEvent(
        id: 'syn_leadership_summit',
        title: 'LEADERSHIP SUMMIT',
        description: 'Annual leadership conference with industry leaders and networking opportunities.',
        date: DateTime(2024, 10, 2),
        endDate: DateTime(2024, 10, 2),
        time: '9:00 AM - 6:00 PM',
        location: 'Main Auditorium',
        type: EventType.seminar,
        scope: EventScope.interCollege,
        maxParticipants: 100,
        currentParticipants: 67,
        fees: 150,
        contactInfo: 'summit@synergy.club',
        highlights: ['Industry leaders panel', 'Networking lunch', 'Leadership workshops'],
        isRegistrationOpen: true,
      ),
    ];

    final synapse = Club(
      id: 'synapse',
      name: 'SYNAPSE',
      shortName: 'Synapse',
      departmentCode: 'BBA',
      tagline: "Leading Tomorrow's Business",
      description: 'Business administration club focusing on leadership, entrepreneurship, and business skills.',
      icon: Icons.business,
      primaryColor: Colors.orange,
      secondaryColor: Colors.orange.shade100,
      memberCount: 89,
      rating: 4.7,
      events: synergyEvents,
      recentActivities: [
        'Corporate Visit to Tech Park - Sep 24',
        'Guest Lecture: Digital Marketing - Sep 20',
        'Business Plan Competition - Sep 15',
      ],
      leadership: [
        const ClubLeader(name: 'Rajesh Gupta', role: 'President'),
        const ClubLeader(name: 'Meera Shah', role: 'Vice President'),
      ],
      achievements: [
        'Won Inter-College B-Plan Contest',
        'Best Business Club Award 2023',
      ],
      establishedDate: DateTime(2017, 6, 10),
      specializations: ['Leadership', 'Entrepreneurship', 'Marketing', 'Finance'],
    );

    return Department(
      code: 'BBA',
      name: 'Bachelor of Business Administration',
      description: 'Department focusing on business management, leadership, and entrepreneurship.',
      primaryColor: Colors.orange,
      icon: Icons.business,
      clubs: [synapse],
      totalMembers: 89,
      totalEvents: 12,
      rating: 4.7,
    );
  }

  // Simplified implementations for other departments
  static Department _getBCOMDepartment() {
    final vanijya = Club(
      id: 'vanijya',
      name: 'VANIJYA',
      shortName: 'Vanijya',
      departmentCode: 'BCOM',
      tagline: 'Commerce & Finance Hub',
      description: 'Commerce club focusing on finance, accounting, and business commerce.',
      icon: Icons.account_balance,
      primaryColor: Colors.green,
      secondaryColor: Colors.green.shade100,
      memberCount: 78,
      rating: 4.6,
      events: [],
      recentActivities: ['Stock Market Analysis - Sep 22'],
      leadership: [const ClubLeader(name: 'Suresh Patel', role: 'President')],
      achievements: ['Finance Quiz Winner 2024'],
      establishedDate: DateTime(2016, 4, 20),
      specializations: ['Finance', 'Accounting', 'Banking', 'Taxation'],
    );

    return Department(
      code: 'BCOM',
      name: 'Bachelor of Commerce',
      description: 'Department of Commerce focusing on finance, accounting, and business.',
      primaryColor: Colors.green,
      icon: Icons.account_balance,
      clubs: [vanijya],
      totalMembers: 78,
      totalEvents: 8,
      rating: 4.6,
    );
  }

  static Department _getBADepartment() {
    final colos = Club(
      id: 'colos',
      name: 'COLOS',
      shortName: 'Colos',
      departmentCode: 'BA',
      tagline: 'Colors of Creativity',
      description: 'Arts club promoting creativity, literature, and cultural activities.',
      icon: Icons.palette,
      primaryColor: Colors.purple,
      secondaryColor: Colors.purple.shade100,
      memberCount: 156,
      rating: 4.9,
      events: [],
      recentActivities: ['Art Exhibition - Sep 25', 'Poetry Competition - Sep 18'],
      leadership: [const ClubLeader(name: 'Kavya Sharma', role: 'President')],
      achievements: ['Best Cultural Club 2024', 'State Level Art Competition Winner'],
      establishedDate: DateTime(2015, 8, 1),
      specializations: ['Fine Arts', 'Literature', 'Drama', 'Music'],
    );

    return Department(
      code: 'BA',
      name: 'Bachelor of Arts',
      description: 'Department of Arts focusing on creativity, literature, and cultural studies.',
      primaryColor: Colors.purple,
      icon: Icons.palette,
      clubs: [colos],
      totalMembers: 156,
      totalEvents: 15,
      rating: 4.9,
    );
  }

  static Department _getBSWDepartment() {
    return Department(
      code: 'BSW',
      name: 'Bachelor of Social Work',
      description: 'Department of Social Work focusing on community service and social welfare.',
      primaryColor: Colors.red,
      icon: Icons.volunteer_activism,
      clubs: [], // No active clubs
      totalMembers: 0,
      totalEvents: 0,
      rating: 0.0,
    );
  }
}