import 'package:flutter/material.dart';

class ClubEvents extends StatelessWidget {
  final Map<String, dynamic> clubData;
  final String departmentCode;

  const ClubEvents({
    super.key,
    required this.clubData,
    required this.departmentCode,
  });

  @override
  Widget build(BuildContext context) {
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
}
