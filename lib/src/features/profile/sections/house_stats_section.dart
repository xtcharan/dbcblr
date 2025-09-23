import 'package:flutter/material.dart';
import '../../../shared/models/house.dart';
import '../../../shared/models/user.dart';

class HouseStatsSection extends StatelessWidget {
  const HouseStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.fake();
    final house = House.fakeList().firstWhere((h) => h.id == user.houseId);
    final houseColor = _houseColor(user.houseId);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 12),
            child: Text(
              'House Statistics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          _row(
            Icons.bar_chart,
            'House Rank',
            '#3 in ${house.name}',
            houseColor,
          ),
          _row(
            Icons.star,
            'Total Points',
            '${house.points} Points',
            houseColor,
          ),
          _row(Icons.calendar_month, 'Member Since', 'August 2023', houseColor),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withValues(alpha: 0.08),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  );

  Widget _row(
    IconData leadingIcon,
    String label,
    String value,
    Color iconColor,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(leadingIcon, color: iconColor),
      title: Text(
        label,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      subtitle: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }

  Color _houseColor(String id) => switch (id) {
    'ruby' => Colors.red,
    'sapphire' => Colors.blue,
    'topaz' => Colors.orange,
    'emerald' => Colors.green,
    _ => Colors.indigo,
  };
}
