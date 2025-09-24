class ClubData {
  static Map<String, dynamic> getClubData(String departmentCode) {
    switch (departmentCode) {
      case 'BCA':
        return {
          'tagline': 'Innovation Through Code',
          'memberCount': 125,
          'rating': 4.8,
          'statsTitle': '📊 CLUB STATS',
          'stats': [
            {'value': '8', 'label': 'Events Month'},
            {'value': '3', 'label': 'This Week'},
            {'value': '12', 'label': 'Competition'},
            {'value': '450+', 'label': 'Projects Done'},
          ],
          'events': [
            {
              'title': '🏆 HACKATHON 2025',
              'date': 'Sep 28-29',
              'time': '48 Hours',
              'location': 'Computer Lab Block',
              'feature': 'Prize Pool: ₹50,000',
              'registration': '12/50 Teams Registered',
              'buttons': ['REGISTER NOW', 'SHARE'],
            },
            {
              'title': '💡 AI Workshop Series',
              'date': 'Oct 5',
              'time': '2:00 PM',
              'location': 'Seminar Hall',
              'feature': 'By Industry Expert',
              'registration': '45/60 Seats',
              'buttons': ['BOOK SEAT', 'DETAILS'],
            },
          ],
          'activitiesTitle': '📋 RECENT ACTIVITIES',
          'activities': [
            'Code Review Session - Sep 20',
            'Flutter Workshop - Sep 18',
            'Tech Talk: Cloud Computing',
            'Project Showcase - Sep 15',
          ],
          'leadershipTitle': '👥 CLUB LEADERSHIP',
          'leadership': [
            {'role': 'President', 'name': '[Name]'},
            {'role': 'Vice President', 'name': '[Name]'},
            {'role': 'Tech Lead', 'name': '[Name]'},
          ],
          'contactButtonText': 'CONTACT',
        };

      case 'BBA':
        return {
          'tagline': "Leading Tomorrow's Business",
          'memberCount': 89,
          'rating': 4.7,
          'statsTitle': '📊 BUSINESS METRICS',
          'stats': [
            {'value': '5', 'label': 'Network Events'},
            {'value': '2', 'label': 'Guest Speaks'},
            {'value': '8', 'label': 'Case Studies'},
            {'value': '15+', 'label': 'Business Plans'},
          ],
          'events': [
            {
              'title': '🎤 LEADERSHIP SUMMIT',
              'date': 'Oct 2',
              'time': 'Full Day',
              'location': 'Main Auditorium',
              'feature': 'Industry Leaders Panel',
              'registration': '67/100 Registered',
              'buttons': ['REGISTER', 'AGENDA'],
            },
            {
              'title': '💼 Startup Pitch Competition',
              'date': 'Oct 8',
              'time': '10:00 AM',
              'location': 'Business Block',
              'feature': 'Winner Gets Mentorship',
              'registration': '5/20 Teams',
              'buttons': ['APPLY NOW', 'RULES'],
            },
          ],
          'activitiesTitle': '📈 RECENT ACHIEVEMENTS',
          'activities': [
            'Won Inter-College B-Plan Contest',
            'Corporate Visit to Tech Park',
            'Guest Lecture: Digital Marketing',
            'Networking Session with Alumni',
          ],
          'leadershipTitle': '👔 EXECUTIVE COMMITTEE',
          'leadership': [
            {'role': 'President', 'name': '[Name]'},
            {'role': 'Vice President', 'name': '[Name]'},
            {'role': 'Events Head', 'name': '[Name]'},
          ],
          'contactButtonText': 'CONNECT',
        };

      case 'BCOM':
        return {
          'tagline': 'Commerce & Finance Hub',
          'memberCount': 78,
          'rating': 4.6,
          'statsTitle': '💹 FINANCE FOCUS',
          'stats': [
            {'value': '6', 'label': 'Market Events'},
            {'value': '4', 'label': 'Tax Works'},
            {'value': '3', 'label': 'Banking Visits'},
            {'value': '25+', 'label': 'Finance Certif'},
          ],
          'events': [
            {
              'title': '📊 STOCK MARKET SIMULATION',
              'date': 'Oct 1-15',
              'time': '2 Weeks',
              'location': 'Commerce Lab',
              'feature': 'Virtual ₹1,00,000 Portfolio',
              'registration': '34/40 Participants',
              'buttons': ['JOIN GAME', 'LEARN'],
            },
            {
              'title': '🏦 Banking Sector Visit',
              'date': 'Oct 12',
              'time': '9:00 AM',
              'location': 'SBI Regional Office',
              'feature': 'Operations & Career Insights',
              'registration': '18/25 Seats',
              'buttons': ['RESERVE', 'MAP'],
            },
          ],
          'activitiesTitle': '🏆 ACHIEVEMENTS',
          'activities': [
            'GST Workshop Completion - 45 Cert',
            'Financial Literacy Campaign',
            'Commerce Quiz Winner - State',
            'Tally Certification Drive',
          ],
          'leadershipTitle': '💼 CLUB COORDINATORS',
          'leadership': [
            {'role': 'President', 'name': '[Name]'},
            {'role': 'Finance Head', 'name': '[Name]'},
            {'role': 'Events Coordinator', 'name': '[Name]'},
          ],
          'contactButtonText': 'REACH OUT',
        };

      case 'BA':
        return {
          'tagline': 'Colors of Creativity',
          'memberCount': 156,
          'rating': 4.9,
          'statsTitle': '🎭 CREATIVE SPECTRUM',
          'stats': [
            {'value': '10', 'label': 'Art Works'},
            {'value': '7', 'label': 'Drama Shows'},
            {'value': '5', 'label': 'Poetry Nights'},
            {'value': '20+', 'label': 'Exhibitions'},
          ],
          'events': [
            {
              'title': '🎪 ANNUAL CULTURAL FESTIVAL',
              'date': 'Oct 20-22',
              'time': '3 Days',
              'location': 'Main Campus',
              'feature': 'Dance, Drama, Art, Music',
              'registration': 'All Students Welcome',
              'buttons': ['PARTICIPATE', 'VOTE'],
            },
            {
              'title': '✍️ Creative Writing Workshop',
              'date': 'Oct 5',
              'time': '2:00 PM',
              'location': 'Literature Room',
              'feature': 'Short Stories & Poetry',
              'registration': '23/30 Writers',
              'buttons': ['ENROLL', 'SAMPLES'],
            },
          ],
          'activitiesTitle': '🏆 RECENT SHOWCASES',
          'activities': [
            'Art Exhibition - "Modern Minds"',
            'Theatre: "Voices of Change"',
            'Poetry Slam Competition',
            'Photography Contest Winner',
          ],
          'leadershipTitle': '🎨 CREATIVE LEADS',
          'leadership': [
            {'role': 'President', 'name': '[Name]'},
            {'role': 'Art Director', 'name': '[Name]'},
            {'role': 'Cultural Secretary', 'name': '[Name]'},
          ],
          'contactButtonText': 'COLLABORATE',
        };

      case 'BSW':
        return {
          'tagline': 'Service Before Self',
          'memberCount': 67,
          'rating': 4.8,
          'statsTitle': '🤝 SOCIAL IMPACT',
          'stats': [
            {'value': '15', 'label': 'Community Drives'},
            {'value': '500+', 'label': 'Lives Impact'},
            {'value': '8', 'label': 'NGO Collab'},
            {'value': '12+', 'label': 'Villages Visited'},
          ],
          'events': [
            {
              'title': '👶 CHILD EDUCATION DRIVE',
              'date': 'Oct 1-31',
              'time': 'Month Long',
              'location': 'Rural Schools - Outskirts',
              'feature': 'Teaching & Material Support',
              'registration': '25/30 Volunteers',
              'buttons': ['VOLUNTEER', 'DONATE'],
            },
            {
              'title': '🌱 Environment Conservation',
              'date': 'Oct 6',
              'time': 'Earth Day Special',
              'location': 'Nearby Villages',
              'feature': 'Tree Plantation Drive',
              'registration': '40/50 Green Warriors',
              'buttons': ['JOIN DRIVE', 'LEARN'],
            },
          ],
          'activitiesTitle': '💫 RECENT IMPACT',
          'activities': [
            'Flood Relief Support - 200 Kits',
            'Digital Literacy for Elders',
            'Health Awareness Camp - 300+',
            'Women Empowerment Workshop',
          ],
          'leadershipTitle': '🙏 SEVA COORDINATORS',
          'leadership': [
            {'role': 'President', 'name': '[Name]'},
            {'role': 'Community Lead', 'name': '[Name]'},
            {'role': 'Project Manager', 'name': '[Name]'},
          ],
          'contactButtonText': 'CONNECT',
        };

      case 'NSS':
        return {
          'tagline': 'NOT ME, BUT YOU',
          'memberCount': 120,
          'rating': 4.9,
          'statsTitle': '📊 SERVICE IMPACT',
          'stats': [
            {'value': '120', 'label': 'Active Volunt'},
            {'value': '1500+', 'label': 'Hours Served'},
            {'value': '25', 'label': 'Projects'},
            {'value': '50+', 'label': 'Villages Covered'},
          ],
          'events': [
            {
              'title': '🏘️ RURAL DEVELOPMENT PROGRAM',
              'date': 'Oct 1-31',
              'time': 'Village Adoption',
              'location': 'Chikkaballapur District',
              'feature': 'Health, Education, Sanitation',
              'registration': '45/60 Volunteers Required',
              'buttons': ['JOIN PROJECT', 'DETAILS'],
            },
            {
              'title': '📚 Digital Literacy Campaign',
              'date': 'Every Weekend',
              'time': '2 Months',
              'location': 'Government Schools',
              'feature': 'Basic Computer Skills',
              'registration': '20/25 Tech Volunteers',
              'buttons': ['TEACH', 'SPONSOR'],
            },
          ],
          'activitiesTitle': '🌟 SPECIAL CAMPS',
          'activities': [
            'Swachh Bharat Summer Camp',
            'Youth Leadership Development',
            'Disaster Management Training',
            'Community Health Awareness',
          ],
          'leadershipTitle': '👨‍💼 NSS COORDINATORS',
          'leadership': [
            {'role': 'Program Officer', 'name': '[Name]'},
            {'role': 'Student Leader', 'name': '[Name]'},
            {'role': 'Activity Coordinator', 'name': '[Name]'},
          ],
          'contactButtonText': 'CONTACT TEAM',
        };

      default:
        return {
          'tagline': 'Club Information',
          'memberCount': 0,
          'rating': 0.0,
          'statsTitle': 'STATS',
          'stats': [
            {'value': '0', 'label': 'Stat 1'},
            {'value': '0', 'label': 'Stat 2'},
            {'value': '0', 'label': 'Stat 3'},
            {'value': '0', 'label': 'Stat 4'},
          ],
          'events': [],
          'activities': [],
          'leadershipTitle': 'LEADERSHIP',
          'leadership': [],
          'contactButtonText': 'CONTACT',
        };
    }
  }
}
