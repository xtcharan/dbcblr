import 'package:flutter/material.dart';
import '../../shared/models/event.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  // TODO: replace with HTTP call later
  List<Event> get _fakeEvents => List.generate(15, (_) => Event.fake());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('College Events')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _fakeEvents.length,
        itemBuilder: (context, i) {
          final e = _fakeEvents[i];
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  e.image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(e.title),
              subtitle: Text(
                '${e.date.substring(0, 10)}  •  ${e.spotsLeft} spots left',
              ),
              trailing: FilledButton.tonal(
                onPressed: () => _join(context, e),
                child: const Text('Join'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _join(BuildContext context, Event e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Joined ${e.title} (fake for now)')));
  }
}
