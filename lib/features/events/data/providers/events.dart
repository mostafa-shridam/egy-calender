import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:calender/core/enums/navigate_to.dart';
import 'package:calender/core/notifications/local_notifications_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/constants_enums.dart';
import '../../../../core/local_services/local_storage.dart';
import '../../../../core/repositories/events/event_repo.dart';
import '../../../../core/repositories/events/events_repo_impl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';

import '../../../../helpers/home_widget_helper.dart';
import '../models/event_category.dart';
import '../models/event_model.dart';
import '../models/event_section.dart';

part 'generated/events.g.dart';

@riverpod
class Events extends _$Events {
  LocalStorage get _storage => LocalStorage.instance;
  EventRepo get _repo => EventsRepoImpl();

  @override
  Future<EventStates> build() async {
    try {
      return _loadFromLocal() ?? EventStates();
    } catch (e, s) {
      log('Events Provider Error', error: e, stackTrace: s);
      return EventStates(error: e.toString());
    }
  }

  // load from local
  EventStates? _loadFromLocal() {
    final eventsRaw = _storage.get(Constants.events.name);
    final categoriesRaw = _storage.get(Constants.categories.name);
    final sectionsRaw = _storage.get(Constants.sections.name);

    if (eventsRaw == null || categoriesRaw == null || sectionsRaw == null) {
      return null;
    }
    final events =
        (jsonDecode(eventsRaw) as List)
            .map((e) => EventModel.fromJson(e))
            .toList();
    if (events.isNotEmpty) {
      events.sort((a, b) {
        // حاول تحويل التاريخ من String لـ DateTime للمقارنة
        final dateA = DateTime.tryParse(a.date ?? '') ?? DateTime(2099);
        final dateB = DateTime.tryParse(b.date ?? '') ?? DateTime(2099);
        return dateA.compareTo(dateB);
      });

      final now = DateTime.now();
      final upcomingEvents =
          events.where((e) {
            final eventDate = DateTime.tryParse(e.date ?? '') ?? DateTime(1900);
            return eventDate.isAfter(now.subtract(const Duration(days: 1)));
          }).toList();

      final widgetItems =
          upcomingEvents.take(10).map((e) => e.toJson(toLocale: true)).toList();

      unawaited(
        HomeWidgetService.updateWidgetList(
          items: widgetItems,

          type: WidgetDataType.events,
        ),
      );
    }
    return EventStates(
      events: events,
      categories:
          (jsonDecode(categoriesRaw) as List)
              .map((e) => EventCategory.fromJson(e))
              .toList(),
      sections:
          (jsonDecode(sectionsRaw) as List)
              .map((e) => EventSection.fromJson(e))
              .toList(),
    );
  }

  // load from remote
  Future<EventStates> _loadFromRemote() async {
    final results = await Future.wait([
      _repo.getEvents(),
      _repo.getCategories(),
      _repo.getSections(),
    ]);
    for (final event in results[0] as List<EventModel>) {
      unawaited(
        ref
            .read(localNotificationsServiceProvider)
            .schedule(
              title: event.titleEn ?? '',
              body: event.descriptionAr ?? '',
              payload: jsonEncode({
                'page': NavigateTo.events.name,
                'id': event.id,
              }),
              delay: event.date ?? "",
            ),
      );
    }
    return EventStates(
      events: results[0] as List<EventModel>,
      categories: results[1] as List<EventCategory>,
      sections: results[2] as List<EventSection>,
    );
  }

  void filterEvents(String categoryId) {
    state = state.whenData((s) => s.copyWith(selectedCategoryId: categoryId));
  }

  /// Manual refresh (Force server)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (!ref.mounted) state;
      final remote = await _loadFromRemote();
      return remote;
    });
  }
}

class EventStates {
  // Core Data
  final List<EventModel> events;
  final List<EventCategory> categories;
  final List<EventSection> sections;

  // Selection
  final String? selectedCategoryId;

  // UI State
  final String? error;

  const EventStates({
    this.events = const [],
    this.categories = const [],
    this.sections = const [],
    this.selectedCategoryId = '0',
    this.error,
  });

  /// --------------------------
  /// Derived State (Getters)
  /// --------------------------

  /// Events filtered by selected category
  List<EventModel> get filteredEvents {
    // HOME → one event per section
    if (selectedCategoryId == '0') {
      final map = <String, EventModel>{};

      for (final event in events) {
        final sectionId = event.sectionId;
        map.putIfAbsent(sectionId ?? '', () => event);
      }

      return map.values.toSet().toList();
    }

    // CATEGORY FILTER
    return events
        .where((e) => e.categoryId == selectedCategoryId)
        .toSet()
        .toList();
  }

  /// Selected category object

  Map<String, EventSection> get sectionsMap {
    return {for (final section in sections) section.id ?? "0": section};
  }

  Map<String, EventCategory> get categoriesMap {
    return {for (final category in categories) category.id ?? "0": category};
  }

  List<EventCategory> get allCategories {
    return [
      EventCategory(
        id: '0',
        nameEn: LocaleKeys.all.tr(),
        nameAr: LocaleKeys.all.tr(),
        color: AppColors.primaryColor.toARGB32(),
        createdAt: '',
        updatedAt: '',
        events: [],
      ),
      ...categories,
    ];
  }

  /// --------------------------
  /// CopyWith
  /// --------------------------

  EventStates copyWith({
    List<EventModel>? events,
    List<EventCategory>? categories,
    List<EventSection>? sections,
    String? selectedCategoryId,
    String? error,
    bool clearError = false,
  }) {
    return EventStates(
      events: events ?? this.events,
      categories: categories ?? this.categories,
      sections: sections ?? this.sections,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      error: clearError ? null : error ?? this.error,
    );
  }

  /// --------------------------
  /// Initial State
  /// --------------------------

  factory EventStates.initial() {
    return const EventStates();
  }
}
