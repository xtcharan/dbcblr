import 'package:flutter/material.dart';

class ClubsPage extends StatelessWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Clubs'),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Clubs & societies here', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
