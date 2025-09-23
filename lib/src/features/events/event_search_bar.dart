import 'package:flutter/material.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Search events...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
              onChanged: onSearch,
            ),
          ),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final hasActiveFilters = filterState.activeCount > 0;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _showFilterModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.filter_list,
              color: hasActiveFilters ? Colors.blueGrey[700] : Colors.grey[600],
            ),
            if (hasActiveFilters)
              Positioned(
                right: 0,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[700],
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      "${filterState.activeCount}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
          return FilterModal(current: filterState, onApply: onFilterApplied);
        },
      ),
    );
  }
}
