import 'package:flutter/material.dart';

class ClubStats extends StatelessWidget {
  final Map<String, dynamic> clubData;

  const ClubStats({super.key, required this.clubData});

  @override
  Widget build(BuildContext context) {
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
}
