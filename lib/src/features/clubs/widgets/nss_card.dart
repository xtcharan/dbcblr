import 'package:flutter/material.dart';
import '../club_detail_page.dart';

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
