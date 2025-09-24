import 'package:flutter/material.dart';

class ClubBanner extends StatelessWidget {
  final Map<String, dynamic> clubData;
  final String departmentCode;

  const ClubBanner({
    super.key,
    required this.clubData,
    required this.departmentCode,
  });

  @override
  Widget build(BuildContext context) {
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
