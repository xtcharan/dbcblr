import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'filter_modal.dart';

class EventSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final FilterState filterState;
  final Function(FilterState) onFilterApplied;

  const EventSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.filterState,
    required this.onFilterApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: onSearch,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onSearch(value);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          _buildFilterButton(context),
        ],
      ),
    );
  }


  Widget _buildFilterButton(BuildContext context) {
    final hasActiveFilters = filterState.activeCount > 0;

    return Container(
      decoration: BoxDecoration(
        color: hasActiveFilters ? Colors.blue[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: hasActiveFilters
            ? Border.all(color: Colors.blue.shade300, width: 1)
            : null,
      ),
      child: IconButton(
        onPressed: () => _showFilterModal(context),
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.tune,
              color: hasActiveFilters ? Colors.blue : Colors.grey[600],
            ),
            if (hasActiveFilters)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${filterState.activeCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return FilterModal(
            current: filterState,
            onApply: onFilterApplied,
          );
        },
      ),
    );
  }
}
