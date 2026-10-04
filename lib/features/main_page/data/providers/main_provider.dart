import 'dart:developer';

import 'package:calender/core/local_services/local_storage.dart';
import 'package:calender/features/events/presentation/events_page.dart';
import 'package:calender/features/price/presentation/prices.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/constants_enums.dart';
import '../../../../core/enums/home_ui.dart';
import '../../../my_events/presentation/my_events.dart';
import '../../../news/presentation/news.dart';
part 'generated/main_provider.g.dart';

@riverpod
class MainProvider extends _$MainProvider {
  late LocalStorage _storage;
  @override
  MainStates build() {
    _storage = LocalStorage.instance;
    final viewTypeString =
        _storage.get(Constants.viewType.name) ?? EventViewType.list.name;
    final viewType = EventViewType.values.firstWhere(
      (e) => e.name == viewTypeString,
      orElse: () => EventViewType.list,
    );
    return MainStates(
      currentIndex: 0,
      widgets: widgets,
      filterType: EventFilterType.ongoing,
      viewType: viewType,
    );
  }

  List<Widget> widgets = [
    const EventsPage(),
    const MyEventsPage(),
    const NewsPage(),
    const PricePage(),
  ];

  void changeIndex(int index) {
    try {
      state = state.copyWith(currentIndex: index);
    } catch (e) {
      log('changeIndex error $e');
    }
  }

  void setFilterType(EventFilterType type) {
    state = state.copyWith(filterType: type);
  }

  void toggleViewType() async {
    final newType =
        state.viewType == EventViewType.list
            ? EventViewType.grid
            : EventViewType.list;
    await _storage.add(Constants.viewType.name, newType.name);
    state = state.copyWith(viewType: newType);
  }
}

class MainStates {
  final int currentIndex;
  final List<Widget> widgets;
  final EventFilterType filterType;
  final EventViewType viewType;
  MainStates({
    required this.currentIndex,
    required this.widgets,
    required this.filterType,
    required this.viewType,
  });

  MainStates copyWith({
    int? currentIndex,
    List<Widget>? widgets,
    EventFilterType? filterType,
    EventViewType? viewType,
  }) {
    return MainStates(
      currentIndex: currentIndex ?? this.currentIndex,
      widgets: widgets ?? this.widgets,
      filterType: filterType ?? this.filterType,
      viewType: viewType ?? this.viewType,
    );
  }
}
