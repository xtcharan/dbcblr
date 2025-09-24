import 'package:flutter/material.dart';

class ClubsPage extends StatelessWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Clubs'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          SectionHeading(title: 'Department Clubs'),
          ClubCard(
            departmentCode: 'BCA',
            clubName: 'BIT BLAZE',
            icon: Icons.computer,
            tagline: 'Innovation Through Code',
            memberCount: 125,
            rating: 4.8,
            nextEvent: 'HACKATHON 2025',
            nextEventDate: 'Sep 28-29',
          ),
          ClubCard(
            departmentCode: 'BBA',
            clubName: 'SYNERGY',
            icon: Icons.bolt,
            tagline: "Leading Tomorrow's Business",
            memberCount: 89,
            rating: 4.7,
            nextEvent: 'LEADERSHIP SUMMIT',
            nextEventDate: 'Oct 2',
          ),
          ClubCard(
            departmentCode: 'BCOM',
            clubName: 'VANIJYA',
            icon: Icons.account_balance,
            tagline: 'Commerce & Finance Hub',
            memberCount: 78,
            rating: 4.6,
            nextEvent: 'STOCK MARKET SIMULATION',
            nextEventDate: 'Oct 1-15',
          ),
          ClubCard(
            departmentCode: 'BA',
            clubName: 'COLOS',
            icon: Icons.palette,
            tagline: 'Colors of Creativity',
            memberCount: 156,
            rating: 4.9,
            nextEvent: 'ANNUAL CULTURAL FESTIVAL',
            nextEventDate: 'Oct 20-22',
          ),
          ClubCard(
            departmentCode: 'BSW',
            clubName: 'SEVA',
            icon: Icons.volunteer_activism,
            tagline: 'Service Before Self',
            memberCount: 67,
            rating: 4.8,
            nextEvent: 'CHILD EDUCATION DRIVE',
            nextEventDate: 'Oct 1-31',
          ),
          SizedBox(height: 24),
          NssCard(),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;

  const SectionHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ClubCard extends StatelessWidget {
  final String departmentCode;
  final String clubName;
  final IconData icon;
  final String tagline;
  final int memberCount;
  final double rating;
  final String nextEvent;
  final String nextEventDate;

  const ClubCard({
    super.key,
    required this.departmentCode,
    required this.clubName,
    required this.icon,
    required this.tagline,
    required this.memberCount,
    required this.rating,
    required this.nextEvent,
    required this.nextEventDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClubDetailPage(
              departmentCode: departmentCode,
              clubName: clubName,
              icon: icon,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getDepartmentColor(
                        departmentCode,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: _getDepartmentColor(departmentCode),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$departmentCode - $clubName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          tagline,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$memberCount Members',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const Spacer(),
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('$rating', style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Next: $nextEvent • $nextEventDate',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('JOIN')),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClubDetailPage(
                          departmentCode: departmentCode,
                          clubName: clubName,
                          icon: icon,
                        ),
                      ),
                    ),
                    icon: const Text('VIEW'),
                    label: const Icon(Icons.arrow_forward, size: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDepartmentColor(String dept) {
    switch (dept) {
      case 'BCA':
        return Colors.indigo;
      case 'BBA':
        return Colors.orange;
      case 'BCOM':
        return Colors.green;
      case 'BA':
        return Colors.purple;
      case 'BSW':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

class NssCard extends StatelessWidget {
  const NssCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.flag, color: Colors.blue, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NATIONAL SERVICE SCHEME',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('NOT ME, BUT YOU', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClubDetailPage(
                    departmentCode: 'NSS',
                    clubName: 'NATIONAL SERVICE SCHEME',
                    icon: Icons.flag,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('VOLUNTEER'),
            ),
          ],
        ),
      ),
    );
  }
}

class ClubDetailPage extends StatelessWidget {
  final String departmentCode;
  final String clubName;
  final IconData icon;

  const ClubDetailPage({
    super.key,
    required this.departmentCode,
    required this.clubName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final clubData = _getClubData(departmentCode);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(clubName),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildBanner(context, clubData),
          _buildStatsSection(clubData),
          _buildEventsSection(clubData),
          _buildActivitiesSection(clubData),
          _buildLeadershipSection(clubData),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context, Map<String, dynamic> clubData) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getClubColor(),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_getClubColor(), _getClubColor().withValues(alpha: 0.7)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            clubData['tagline'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.people, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                '${clubData['memberCount']} Members',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                '${clubData['rating']}★',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Map<String, dynamic> clubData) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clubData['statsTitle'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var stat in clubData['stats'])
                Expanded(
                  child: Card(
                    elevation: 0,
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Text(
                            stat['value'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stat['label'],
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection(Map<String, dynamic> clubData) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 UPCOMING EVENTS',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (var event in clubData['events']) _buildEventCard(event),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['title'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14),
                const SizedBox(width: 4),
                Text('${event['date']} • ${event['time']}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14),
                const SizedBox(width: 4),
                Text(event['location']),
              ],
            ),
            const SizedBox(height: 4),
            if (event.containsKey('feature'))
              Row(
                children: [
                  const Icon(Icons.star, size: 14),
                  const SizedBox(width: 4),
                  Text(event['feature']),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, size: 14),
                const SizedBox(width: 4),
                Text(event['registration']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getClubColor(),
                  ),
                  child: Text(event['buttons'][0]),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {},
                  icon: Text(event['buttons'][1]),
                  label: const Icon(Icons.arrow_forward, size: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesSection(Map<String, dynamic> clubData) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clubData['activitiesTitle'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (var activity in clubData['activities'])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(child: Text(activity)),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Text('VIEW ALL'),
              label: const Icon(Icons.arrow_forward, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadershipSection(Map<String, dynamic> clubData) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clubData['leadershipTitle'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (var leader in clubData['leadership'])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Text('🔹 '),
                  Text('${leader['role']}: ${leader['name']}'),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: Text(clubData['contactButtonText']),
              label: const Icon(Icons.arrow_forward, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getClubColor() {
    switch (departmentCode) {
      case 'BCA':
        return Colors.indigo;
      case 'BBA':
        return Colors.orange;
      case 'BCOM':
        return Colors.green;
      case 'BA':
        return Colors.purple;
      case 'BSW':
        return Colors.red;
      case 'NSS':
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }

  Map<String, dynamic> _getClubData(String departmentCode) {
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
      // ...add BCOM, BA, BSW, NSS similarly...
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
