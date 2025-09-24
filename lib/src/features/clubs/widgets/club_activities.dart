import 'package:flutter/material.dart';

class ClubActivities extends StatelessWidget {
  final Map<String, dynamic> clubData;

  const ClubActivities({super.key, required this.clubData});

  @override
  Widget build(BuildContext context) {
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
}
