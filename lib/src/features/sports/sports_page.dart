import 'package:flutter/material.dart';

class SportsPage extends StatelessWidget {
  const SportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Sports'),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Sports and physical activities',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
