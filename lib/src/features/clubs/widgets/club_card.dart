import 'package:flutter/material.dart';
import '../club_detail_page.dart';

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
