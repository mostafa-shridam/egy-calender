import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:calender/core/enums/navigate_to.dart';
import 'package:calender/core/helper/icon_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/helper/help_functions.dart';
import '../../../../core/notifications/local_notifications_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../models/my_category.dart';
import '../models/my_event.dart';
import '../repository/my_category_repo.dart';
import '../repository/my_category_repo_impl.dart';
import '../repository/my_event_repository.dart';
import '../repository/my_event_repository_impl.dart';

part 'generated/my_events.g.dart';

/// Unified state class - single source of truth
class MyEventsState {
  final List<MyEvent> events;
  final List<MyCategory> categories;
  final String? selectedCategoryId;
  final int priority;
  final String? startAt;
  final String? endAt;
  final String? imageUrl;
  final String? error;

  const MyEventsState({
    this.events = const [],
    this.categories = const [],
    this.selectedCategoryId = '0',
    this.priority = 0,
    this.startAt,
    this.endAt,
    this.imageUrl,
    this.error,
  });

  /// Filtered events based on selected category
  List<MyEvent> get filteredEvents {
    if (selectedCategoryId == null || selectedCategoryId == '0') {
      return events;
    }
    return events.where((e) => e.categoryId == selectedCategoryId).toList();
  }

  /// All categories including "All" option
  List<MyCategory> get allCategories {
    return [
      MyCategory(
        id: '0',
        name: LocaleKeys.all.tr(),
        color: AppColors.primaryColor.toARGB32(),
        icon: IconHelper.getIconName(Icons.event),
      ),
      ...categories,
    ];
  }

  /// Categories map for quick lookup
  Map<String, MyCategory> get categoriesMap {
    return {for (final category in categories) category.id ?? '0': category};
  }

  /// Validation error (null if valid)
  String? get validationError {
    if (startAt == null || startAt!.isEmpty) {
      return LocaleKeys.eventDateIsRequired.tr();
    }

    final parsedStartDate = DateTime.tryParse(startAt!);
    final parsedEndDate =
        DateTime.tryParse(endAt ?? '') ??
        DateTime.parse(startAt!).add(const Duration(hours: 1));

    if (parsedStartDate == null) {
      return 'Invalid date format';
    }

    if (parsedStartDate.isAfter(parsedEndDate)) {
      return 'End date must be after start date';
    }

    return null;
  }

  MyEventsState copyWith({
    List<MyEvent>? events,
    List<MyCategory>? categories,
    String? selectedCategoryId,
    int? priority,
    String? startAt,
    String? endAt,
    String? imageUrl,
    String? error,
    bool clearError = false,
    bool clearImage = false,
    bool clearDates = false,
  }) {
    return MyEventsState(
      events: events ?? this.events,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      priority: priority ?? this.priority,
      startAt: clearDates ? null : (startAt ?? this.startAt),
      endAt: clearDates ? null : (endAt ?? this.endAt),
      imageUrl: clearImage ? null : (imageUrl ?? this.imageUrl),
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// Reset form state only (keep events and categories)
  MyEventsState resetForm() {
    return MyEventsState(
      events: events,
      categories: categories,
      selectedCategoryId: null,
      priority: 0,
      startAt: null,
      endAt: null,
      imageUrl: null,
      error: null,
    );
  }

  /// Initialize form from existing event (for edit mode)
  MyEventsState initializeFromEvent(MyEvent event) {
    return copyWith(
      selectedCategoryId:
          event.categoryId?.isEmpty == false ? event.categoryId : '0',
      priority: event.priority ?? 0,
      startAt: event.startAt,
      endAt: event.endAt,
      imageUrl: event.image,
      clearError: true,
    );
  }
}

@riverpod
class MyEvents extends _$MyEvents {
  late final MyEventsRepository _eventsRepository;
  late final MyCategoryRepo _categoryRepo;

  @override
  FutureOr<MyEventsState> build() async {
    _eventsRepository = MyEventRepositoryImpl.instance;
    _categoryRepo = MyCategoryRepoImpl.instance;

    return await _loadInitialData();
  }

  /// Load initial data (events and categories)
  Future<MyEventsState> _loadInitialData() async {
    try {
      final categoriesResult = await _categoryRepo.getCategories();
      final eventsResult = await _eventsRepository.getEvents();

      return MyEventsState(events: eventsResult, categories: categoriesResult);
    } catch (e, stackTrace) {
      log('Error loading initial data', error: e, stackTrace: stackTrace);
      throw Exception('Failed to load data: ${e.toString()}');
    }
  }

  /// Reload all data
  Future<void> reloadData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadInitialData();
    });
  }

  // ==================== FORM STATE METHODS ====================

  /// Initialize form for editing an existing event
  /// CRITICAL: Call this when navigating to edit mode
  void initializeFormForEdit(MyEvent event) {
    state.whenData((currentState) {
      state = AsyncValue.data(currentState.initializeFromEvent(event));
    });
  }

  /// Select a category
  void selectCategory(String categoryId) {
    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(selectedCategoryId: categoryId, clearError: true),
      );
    });
  }

  /// Set priority
  void setPriority(int priority) {
    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(priority: priority, clearError: true),
      );
    });
  }

  String? getPriortyString(int priority) {
    switch (priority) {
      case 0:
        return LocaleKeys.priority_low.tr();
      case 1:
        return LocaleKeys.priority_medium.tr();
      case 2:
        return LocaleKeys.priority_high.tr();
      default:
        return null;
    }
  }

  /// Pick and set start date/time
  Future<void> setStartAt(BuildContext context) async {
    try {
      final pickDate = await selectDate(context: context);
      if (pickDate == null) return;

      if (!context.mounted) return;
      final time = await selectTime(context: context);

      final dateTime = DateTime(
        pickDate.year,
        pickDate.month,
        pickDate.day,
        time?.hour ?? 0,
        time?.minute ?? 0,
      );

      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(
            startAt: dateTime.toIso8601String(),
            endAt: dateTime.add(Duration(hours: 1)).toIso8601String(),
            clearError: true,
          ),
        );
      });
    } catch (e, stackTrace) {
      log('Error picking start date', error: e, stackTrace: stackTrace);
    }
  }

  /// Pick and set end date/time
  Future<void> setEndAt(BuildContext context) async {
    try {
      final pickDate = await selectDate(context: context);
      if (pickDate == null) return;

      if (!context.mounted) return;
      final time = await selectTime(context: context);

      final dateTime = DateTime(
        pickDate.year,
        pickDate.month,
        pickDate.day,
        time?.hour ?? 0,
        time?.minute ?? 0,
      );

      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(
            endAt: dateTime.toIso8601String(),
            clearError: true,
          ),
        );
      });
    } catch (e, stackTrace) {
      log('Error picking end date', error: e, stackTrace: stackTrace);
    }
  }

  /// Set image URL
  void setImageUrl(String? imageUrl) {
    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(
          imageUrl: imageUrl,
          clearImage: imageUrl == null,
          clearError: true,
        ),
      );
    });
  }

  /// Reset form state
  void resetForm() {
    state.whenData((currentState) {
      state = AsyncValue.data(currentState.resetForm());
    });
  }

  // ==================== EVENT CRUD METHODS ====================

  /// Add a new event
  Future<void> addEvent(MyEvent event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value;
      if (currentState == null) {
        throw Exception('State not initialized');
      }
      final diff = DateTime.parse(
        event.startAt ?? '',
      ).difference(DateTime.now());
      if (diff.isNegative) {
        log('Start date must be after current date');
        throw Exception('Start date must be after current date');
      }
      log('diff: $diff');
      await _eventsRepository.addEvent(event);
      final updatedEvents = await _eventsRepository.getEvents();
      _notifications(event);
      return currentState
          .copyWith(events: updatedEvents, clearError: true)
          .resetForm();
    });
  }

  /// Update an existing event
  Future<void> updateEvent(MyEvent event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value;
      if (currentState == null) {
        throw Exception('State not initialized');
      }

      await _eventsRepository.updateEvent(event);
      final updatedEvents = await _eventsRepository.getEvents();
      _notifications(event);
      return currentState
          .copyWith(events: updatedEvents, clearError: true)
          .resetForm();
    });
  }

  void _notifications(MyEvent event) async {
    unawaited(
      LocalNotificationsService.instance.schedule(
        title: event.title ?? 'Event Reminder',
        body: event.description ?? 'You have an upcoming event.',
        delay: event.startAt ?? "",
        priority: event.priority ?? 1,
        payload: jsonEncode({'page': NavigateTo.myEvents.name, 'id': event.id}),
      ),
    );
  }

  /// Delete an event
  Future<void> deleteEvent(String eventId) async {
    state = const AsyncValue.loading();
    state.value?.events.removeWhere((event) => event.id == eventId);

    state = await AsyncValue.guard(() async {
      final currentState = state.value;
      if (currentState == null) {
        throw Exception('State not initialized');
      }

      await _eventsRepository.deleteEvent(eventId);
      final updatedEvents = await _eventsRepository.getEvents();
      return currentState.copyWith(events: updatedEvents, clearError: true);
    });
  }

  // ==================== CATEGORY CRUD METHODS ====================

  /// Add a new category
  Future<void> addCategory(MyCategory category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value;
      if (currentState == null) {
        throw Exception('State not initialized');
      }

      await _categoryRepo.addCategory(category);
      final updatedCategories = await _categoryRepo.getCategories();

      return currentState.copyWith(
        categories: updatedCategories,
        clearError: true,
      );
    });
  }

  /// Update an existing category
  Future<void> updateCategory(MyCategory category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value;
      if (currentState == null) {
        throw Exception('State not initialized');
      }

      await _categoryRepo.updateCategory(category);
      final updatedCategories = await _categoryRepo.getCategories();

      return currentState.copyWith(
        categories: updatedCategories,
        clearError: true,
      );
    });
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentState = state.value;
      if (currentState == null) {
        throw Exception('State not initialized');
      }

      await _categoryRepo.deleteCategory(categoryId);
      final updatedCategories = await _categoryRepo.getCategories();

      return currentState.copyWith(
        categories: updatedCategories,
        clearError: true,
      );
    });
  }

  Future<void> migrateGuestData() async {
    await _eventsRepository.migrateGuestData();
    await _categoryRepo.migrateGuestData();
  }
  // ==================== FILTERING ====================

  /// Filter events by category (merged with selectCategory for simplicity)
  void filterByCategory(String categoryId) {
    selectCategory(categoryId);
  }
}
