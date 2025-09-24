import 'package:flutter/material.dart';

class ClubLeadership extends StatelessWidget {
  final Map<String, dynamic> clubData;

  const ClubLeadership({super.key, required this.clubData});

  @override
  Widget build(BuildContext context) {
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
}
