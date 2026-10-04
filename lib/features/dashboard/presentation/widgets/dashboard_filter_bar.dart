import 'package:calender/core/constants/constants.dart';
import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/categories.dart';
import '../../data/providers/sections.dart';
import '../../data/providers/event_filter_provider.dart';

class DashboardFilterBar extends ConsumerStatefulWidget {
  const DashboardFilterBar({super.key});

  @override
  ConsumerState<DashboardFilterBar> createState() => _DashboardFilterBarState();
}

class _DashboardFilterBarState extends ConsumerState<DashboardFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(eventFilterProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final sectionsAsync = ref.watch(sectionsProvider);

    // Sync controller text with filter state when reset happens
    if (filterState.searchQuery.isEmpty && _searchController.text.isNotEmpty) {
      _searchController.clear();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Search Bar with debouncing
          MyTextField(
            controller: _searchController,
            onChanged: (value) {
              // Use debounced method to prevent filtering on every keystroke
              ref
                  .read(eventFilterProvider.notifier)
                  .setSearchQueryDebounced(value);
            },
            hintText: 'Search',
            prefixIcon: Icons.search,
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        // Use immediate update for clear action
                        ref
                            .read(eventFilterProvider.notifier)
                            .setSearchQuery('');
                      },
                    )
                    : null,
          ),
          const SizedBox(height: 16),

          // Row 2: Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Category Filter
                _buildDropdown<String>(
                  context: context,
                  label: "Category",
                  value: filterState.categoryId,
                  items: categoriesAsync.when(
                    data:
                        (categories) =>
                            categories
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name(context)),
                                  ),
                                )
                                .toList(),
                    error: (_, _) => [],
                    loading: () => [],
                  ),
                  onChanged: (val) {
                    ref.read(eventFilterProvider.notifier).setCategory(val);
                  },
                  isLoading: categoriesAsync.isLoading,
                ),
                const SizedBox(width: 12),

                // Section Filter
                _buildDropdown<String>(
                  context: context,
                  label: "Section",
                  value: filterState.sectionId,
                  items: sectionsAsync.when(
                    data:
                        (sections) =>
                            sections
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s.id,
                                    child: Text(s.title(context)),
                                  ),
                                )
                                .toList(),
                    error: (_, _) => [],
                    loading: () => [],
                  ),
                  onChanged: (val) {
                    ref.read(eventFilterProvider.notifier).setSection(val);
                  },
                  isLoading: sectionsAsync.isLoading,
                ),
                const SizedBox(width: 12),

                // Date Filter Button
                OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: filterState.selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      ref.read(eventFilterProvider.notifier).setDate(date);
                    }
                  },
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    filterState.selectedDate != null
                        ? formatDateTime(
                          filterState.selectedDate!.toIso8601String(),
                          context,
                          format: dateOnlyFormat,
                        )
                        : 'Select Date',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                if (filterState.selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed:
                        () => ref
                            .read(eventFilterProvider.notifier)
                            .setDate(null),
                    tooltip: "Clear Date",
                  ),

                const SizedBox(width: 12),

                // Reset All
                if (filterState.categoryId != null ||
                    filterState.sectionId != null ||
                    filterState.selectedDate != null ||
                    filterState.searchQuery.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      ref.read(eventFilterProvider.notifier).resetAll();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset All'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    bool isLoading = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value == null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: items.any((item) => item.value == value) ? value : null,
              items: items,
              onChanged: onChanged,
              hint:
                  isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(label),
              icon: const Icon(Icons.arrow_drop_down),
              style: Theme.of(context).textTheme.bodyMedium,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          if (value != null)
            IconButton(
              onPressed: () => onChanged(null),
              icon: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }
}
