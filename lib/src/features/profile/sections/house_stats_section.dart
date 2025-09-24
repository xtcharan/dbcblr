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
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Text(
              'House Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          _row(
            Icons.bar_chart,
            'House Rank',
            '#3 in ${house.name}',
            houseColor,
            context,
          ),
          _row(
            Icons.star,
            'Total Points',
            '${house.points} Points',
            houseColor,
            context,
          ),
          _row(Icons.calendar_month, 'Member Since', 'August 2023', houseColor, context),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) => BoxDecoration(
    color: Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : const Color(0xFF242424),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.2),
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
    BuildContext context,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(leadingIcon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black54  // Darker for better contrast in light mode
              : Colors.grey[300],
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,  // Added bold for better readability
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black87  // Much darker in light mode
              : Colors.white,
        ),
      ),
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
