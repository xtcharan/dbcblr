import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  final FilterState current;
  final Function(FilterState) onApply;

  const FilterModal({super.key, required this.current, required this.onApply});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late FilterState _state; // local working copy

  @override
  void initState() {
    super.initState();
    _state = widget.current.copy(); // clone so we can cancel
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // header
          ListTile(
            leading: const SizedBox.shrink(),
            title: const Text(
              'Filter Events',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: TextButton(
              onPressed: _clearAll,
              child: const Text('Clear All'),
            ),
          ),
          const Divider(height: 1),
          // content
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _sectionTitle('Categories'),
                _chips(
                  _state.categories,
                  _cats,
                  (v) => setState(() => _state.categories = v),
                ),
                const SizedBox(height: 16),
                _sectionTitle('Date Range'),
                _radioGroup(
                  _state.dateRange,
                  _dateOpts,
                  (v) => setState(() => _state.dateRange = v),
                ),
                const SizedBox(height: 16),
                _sectionTitle('House Events'),
                _houseToggle(),
                const SizedBox(height: 16),
                _sectionTitle('Location'),
                _chips(
                  _state.locations,
                  _locs,
                  (v) => setState(() => _state.locations = v),
                ),
              ],
            ),
          ),
          // apply button
          SafeArea(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700],
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onApply(_state);
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // data --------------------------------------------------------------------
  final _cats = ['Academic', 'Cultural', 'Sports', 'Social'];
  final _dateOpts = ['Today', 'This Week', 'This Month', 'Custom Range'];
  final _locs = [
    'Main Auditorium',
    'Sports Complex',
    'Library',
    'Cafeteria',
    'Outdoor Ground',
  ];

  // helpers -----------------------------------------------------------------
  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );

  Widget _chips(
    Set<String> selected,
    List<String> options,
    ValueChanged<Set<String>> onChange,
  ) {
    return Wrap(
      spacing: 8,
      children: options.map((o) {
        final isSelected = selected.contains(o);
        return ChoiceChip(
          label: Text(o),
          selected: isSelected,
          onSelected: (_) {
            final newSet = Set<String>.from(selected);
            if (isSelected) {
              newSet.remove(o);
            } else {
              newSet.add(o);
            }
            onChange(newSet);
          },
          selectedColor: Colors.grey[200],
          backgroundColor: Colors.grey[100],
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : Colors.black87,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? Colors.grey[400]! : Colors.transparent,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _radioGroup(
    String selected,
    List<String> options,
    ValueChanged<String> onChange,
  ) {
    return Column(
      children: options.map((option) {
        return ListTile(
          title: Text(option, style: const TextStyle(fontSize: 13)),
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: Theme(
            data: ThemeData(unselectedWidgetColor: Colors.grey[400]),
            child: Transform.scale(
              scale: 0.9,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected == option
                        ? Colors.blueGrey[700]!
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: selected == option
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          onTap: () => onChange(option),
        );
      }).toList(),
    );
  }

  Widget _houseToggle() {
    return SwitchListTile(
      title: const Text(
        'Show House-specific Events Only',
        style: TextStyle(fontSize: 13),
      ),
      value: _state.houseOnly,
      onChanged: (v) => setState(() => _state.houseOnly = v),
      dense: true,
      contentPadding: EdgeInsets.zero,
      activeThumbColor: Colors.blueGrey[700],
    );
  }

  void _clearAll() => setState(() => _state = FilterState.empty());
}

// ---------------------------------------------------------------------------
// filter state object (clean, serialisable later)
class FilterState {
  Set<String> categories;
  String dateRange;
  bool houseOnly;
  Set<String> locations;

  FilterState({
    required this.categories,
    required this.dateRange,
    required this.houseOnly,
    required this.locations,
  });

  factory FilterState.empty() => FilterState(
    categories: {},
    dateRange: 'This Month',
    houseOnly: false,
    locations: {},
  );

  FilterState copy() => FilterState(
    categories: Set.from(categories),
    dateRange: dateRange,
    houseOnly: houseOnly,
    locations: Set.from(locations),
  );

  int get activeCount =>
      categories.length +
      (dateRange != 'This Month' ? 1 : 0) +
      (houseOnly ? 1 : 0) +
      locations.length;
}
