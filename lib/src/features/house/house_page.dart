import 'package:flutter/material.dart';
import '../../shared/models/house.dart';
import '../../shared/models/activity.dart';
import 'activity_header.dart';
import 'activity_card.dart';

class HousePage extends StatefulWidget {
  const HousePage({super.key});

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final houses = House.fakeList()
      ..sort((a, b) => b.points.compareTo(a.points));

    final activities = Activity.fakeFeed();
    final filteredActivities = _filter == 'All'
        ? activities
        : activities
              .where((a) => a.category.toLowerCase() == _filter.toLowerCase())
              .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('House Standings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // House standings section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'House Standings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          ...houses.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HouseCard(house: entry.value, rank: entry.key + 1),
            ),
          ),

          // Recent activities section
          ActivityHeader(
            filter: _filter,
            onFilterChanged: (value) => setState(() => _filter = value),
          ),
          ...filteredActivities.map(
            (activity) => ActivityCard(activity: activity),
          ),
        ],
      ),
    );
  }
}

class HouseCard extends StatelessWidget {
  final House house;
  final int rank;

  const HouseCard({super.key, required this.house, required this.rank});

  // helpers ------------------------------------------------------------------
  Color get _borderColor =>
      Color(int.parse(house.colorHex.substring(1), radix: 16) + 0xFF000000);

  Color get _statusColor => switch (house.status) {
    'Rising' => Colors.green,
    'Falling' => Colors.red,
    _ => Colors.grey,
  };

  IconData get _statusIcon => switch (house.status) {
    'Rising' => Icons.trending_up,
    'Falling' => Icons.trending_down,
    _ => Icons.trending_flat,
  };

  // UI -----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: _borderColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // left: rank + mascot
            _leftBadge(),
            const SizedBox(width: 20),

            // centre: name + points
            _centerInfo(),
            const SizedBox(width: 12),

            // right: trend chip
            _trendChip(),
          ],
        ),
      ),
    );
  }

  Widget _leftBadge() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // rank
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: _borderColor, shape: BoxShape.circle),
        child: Center(
          child: Text(
            '$rank',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      // mascot
      Text(house.mascot, style: const TextStyle(fontSize: 32)),
    ],
  );

  Widget _centerInfo() => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          house.name,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${house.points}',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _borderColor,
          ),
        ),
        const SizedBox(height: 2),
        Text('points', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    ),
  );

  Widget _trendChip() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: _statusColor.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_statusIcon, size: 16, color: _statusColor),
        const SizedBox(width: 4),
        Text(house.status, style: TextStyle(fontSize: 12, color: _statusColor)),
      ],
    ),
  );
}
