import 'dart:async'; // <-- gives you Timer
import 'dart:math'; // <-- gives you Random
import 'package:flutter/material.dart';

class HousePage extends StatefulWidget {
  const HousePage({super.key});

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  // DBC houses — same names you already chose
  final _houses = [
    _House('Ruby Rhinos', Colors.red, 1240),
    _House('Sapphire Sharks', Colors.blue, 1180),
    _House('Topaz Tigers', Colors.amber, 1320),
    _House('Emerald Eagles', Colors.green, 1150),
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // fake live updates every 2 s
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      final random = Random();
      setState(() {
        _houses[random.nextInt(4)].points += random.nextInt(5) + 1;
        _houses.sort((a, b) => b.points.compareTo(a.points));
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('House Leaderboard')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _houses.length,
        itemBuilder: (context, i) {
          final h = _houses[i];
          return Card(
            color: h.color.withValues(alpha: 0.15), // new Flutter 3.27+ API
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: h.color,
                child: Text(
                  '#${i + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                h.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '${h.points}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        },
      ),
    );
  }
}

// tiny private model
class _House {
  final String name;
  final Color color;
  int points;

  _House(this.name, this.color, this.points);
}
