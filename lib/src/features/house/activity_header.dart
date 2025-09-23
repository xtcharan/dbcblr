import 'package:flutter/material.dart';

class ActivityHeader extends StatelessWidget {
  final String filter;
  final ValueChanged<String> onFilterChanged;
  const ActivityHeader({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          const Text(
            'Recent Point Activities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: filter,
            underline: const SizedBox(),
            items: const [
              'All',
              'Sports',
              'Academic',
              'Cultural',
              'Community',
              'Science',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => onFilterChanged(v!),
          ),
        ],
      ),
    );
  }
}
