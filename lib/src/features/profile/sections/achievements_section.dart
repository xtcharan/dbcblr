import 'package:flutter/material.dart';
import '../../../shared/models/badge.dart' as models;

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = models.Badge.fakeList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  /* push full grid later */
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 3-column grid (latest 6)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: GridView.count(
              key: ValueKey<int>(badges.length), // key for animation
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
              children: badges.take(6).map((b) => _badgeCard(b, context)).toList(),
            ),
          ),
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

  Widget _badgeCard(models.Badge badge, BuildContext context) {
    final color = _tierColor(badge.tier);
    final locked = badge.earnedOn == null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // badge circle
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: locked ? Colors.grey[300]! : color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: locked ? Colors.grey : color, width: 2),
          ),
          child: Center(
            child: Text(
              badge.icon,
              style: TextStyle(
                fontSize: 24,
                color: locked ? Colors.grey[600] : Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // title
        Text(
          badge.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        // date or lock
        Text(
          locked
              ? 'Locked'
              : '${badge.earnedOn!.day} ${_month(badge.earnedOn!)}',
          style: TextStyle(
            fontSize: 10,
            color: locked ? Colors.grey : Colors.green,
          ),
        ),
      ],
    );
  }

  Color _tierColor(String tier) => switch (tier) {
    'bronze' => Colors.brown,
    'silver' => Colors.grey,
    'gold' => Colors.amber,
    'platinum' => Colors.indigo,
    _ => Colors.blue,
  };

  String _month(DateTime d) => switch (d.month) {
    1 => 'Jan',
    2 => 'Feb',
    3 => 'Mar',
    4 => 'Apr',
    5 => 'May',
    6 => 'Jun',
    7 => 'Jul',
    8 => 'Aug',
    9 => 'Sep',
    10 => 'Oct',
    11 => 'Nov',
    12 => 'Dec',
    _ => '',
  };
}
