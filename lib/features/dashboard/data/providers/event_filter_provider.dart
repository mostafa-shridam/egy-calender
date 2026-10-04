import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'events.dart';
import '../../../events/data/models/event_model.dart';

part 'generated/event_filter_provider.g.dart';

@riverpod
class EventFilterNotifier extends _$EventFilterNotifier {
  Timer? _searchDebounceTimer;

  @override
  EventFilterState build() {
    // Cancel timer when provider is disposed
    ref.onDispose(() {
      _searchDebounceTimer?.cancel();
    });
    return const EventFilterState();
  }

  /// Set search query with debouncing (500ms delay)
  /// This prevents the filter from running on every keystroke
  void setSearchQueryDebounced(String query) {
    // Cancel previous timer if exists
    _searchDebounceTimer?.cancel();

    // Start new timer
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      state = state.copyWith(searchQuery: query);
    });
  }

  /// Set search query immediately (use for programmatic updates like reset)
  void setSearchQuery(String query) {
    _searchDebounceTimer?.cancel();
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId);
  }

  void setSection(String? sectionId) {
    state = state.copyWith(sectionId: sectionId);
  }

  void setDate(DateTime? date) {
    state = state.copyWith(selectedDate: date);
  }

  void resetAll() {
    _searchDebounceTimer?.cancel();
    state = const EventFilterState();
  }
}

/// Synchronous filtered events provider
/// Returns filtered list instantly without async loading states
@riverpod
List<EventModel> filteredEvents(Ref ref) {
  // Watch AsyncValue directly, don't await
  final eventsAsync = ref.watch(eventsProvider);
  final filterState = ref.watch(eventFilterProvider);

  // Get current events or empty list if still loading
  // This prevents loading state from propagating to filtered results
  final events = eventsAsync.value ?? [];

  // Perform synchronous filtering on the in-memory list
  return events.where((event) {
    // 1. Search Query - search in Arabic and English text fields
    if (filterState.searchQuery.isNotEmpty) {
      final q = filterState.searchQuery.toLowerCase();
      final matchesSearch =
          event.titleAr!.toLowerCase().contains(q) ||
          event.titleEn!.toLowerCase().contains(q) ||
          event.descriptionAr!.toLowerCase().contains(q) ||
          event.descriptionEn!.toLowerCase().contains(q);

      if (!matchesSearch) return false;
    }

    // 2. Category Filter
    if (filterState.categoryId != null && filterState.categoryId!.isNotEmpty) {
      if (event.categoryId != filterState.categoryId) return false;
    }

    // 3. Section Filter
    if (filterState.sectionId != null && filterState.sectionId!.isNotEmpty) {
      if (event.sectionId != filterState.sectionId) return false;
    }

    // 4. Date Filter
    if (filterState.selectedDate != null) {
      try {
        final eventDate = DateTime.tryParse(event.date ?? '');
        if (eventDate != null) {
          final isSameDate = DateUtils.isSameDay(
            eventDate,
            filterState.selectedDate!,
          );
          if (!isSameDate) return false;
        }
      } catch (e) {
        // Ignore date filter on parse error
      }
    }

    return true;
  }).toList();
}
class EventFilterState {
  final String searchQuery;
  final String? categoryId;
  final String? sectionId;
  final DateTime? selectedDate;

  const EventFilterState({
    this.searchQuery = '',
    this.categoryId,
    this.sectionId,
    this.selectedDate,
  });

  EventFilterState copyWith({
    String? searchQuery,
    String? categoryId,
    String? sectionId,
    DateTime? selectedDate,
  }) {
    return EventFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      sectionId: sectionId ?? this.sectionId,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
