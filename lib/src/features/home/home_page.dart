import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('Home'),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Home feed / announcements here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
