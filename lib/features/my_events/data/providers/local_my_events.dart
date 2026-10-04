import 'dart:convert';
import 'dart:developer';
import 'package:calender/core/helper/help_functions.dart';
import '../../../../core/enums/constants_enums.dart';
import '../../../../core/local_services/local_storage.dart';
import '../models/my_event.dart';
import '../models/my_category.dart';

class LocalMyEvents {
  static final LocalMyEvents _instance = LocalMyEvents._();
  static LocalMyEvents get instance => _instance;
  LocalMyEvents._();

  final LocalStorage _storage = LocalStorage.instance;
  final String _eventsKey = Constants.myEvents.name;
  final String _categoriesKey = Constants.myCategories.name;

  // ميثود واحدة عامة للحفظ عشان نقلل تكرار الكود
  Future<void> _saveToStorage(String key, List<dynamic> list) async {
    final String encodedData = jsonEncode(list.map((e) => e.toJson()).toList());
    await _storage.add(key, encodedData);
  }

  // --- EVENTS METHODS ---
  Future<List<MyEvent>> getEvents() async {
    final String? data = await _storage.get(_eventsKey);
    if (data == null || !dataIsNotEmpty(data: data)) return [];

    try {
      final List decoded = jsonDecode(data);
      final events =
          decoded
              .map((e) => MyEvent.fromJson(e as Map<String, dynamic>))
              .toList();

      // الترتيب
      events.sort((a, b) {
        if (a.startAt == null) return 1;
        if (b.startAt == null) return -1;
        return a.startAt!.compareTo(b.startAt!);
      });
      return events;
    } catch (e) {
      log('Error decoding events: $e');
      return [];
    }
  }

  Future<void> addEvent(MyEvent event) async {
    final events = await getEvents();
    // حماية: لو الـ ID موجود فعلاً، حدثه بدل ما تضيفه تاني
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      events[index] = event;
    } else {
      events.add(event);
    }
    await _saveToStorage(_eventsKey, events);
  }

  Future<void> updateEvent(MyEvent updatedEvent) async =>
      addEvent(updatedEvent);

  Future<void> deleteEvent(String id) async {
    final events = await getEvents();
    events.removeWhere((e) => e.id == id);
    await _saveToStorage(_eventsKey, events);
  }

  Future<void> saveAllEvents(List<MyEvent> events) =>
      _saveToStorage(_eventsKey, events);

  // --- CATEGORIES METHODS ---
  Future<List<MyCategory>> getCategories() async {
    final String? data = await _storage.get(_categoriesKey);
    if (data == null || !dataIsNotEmpty(data: data)) return [];

    try {
      final List decoded = jsonDecode(data);
      return decoded
          .map((e) => MyCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error decoding categories: $e');
      return [];
    }
  }

  Future<void> addCategory(MyCategory category) async {
    final categories = await getCategories();
    // حماية: منع التكرار
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category;
    } else {
      categories.add(category);
    }
    await _saveToStorage(_categoriesKey, categories);
  }

  Future<void> updateCategory(MyCategory updatedCategory) async =>
      addCategory(updatedCategory);

  Future<void> deleteCategory(String id) async {
    final categories = await getCategories();
    categories.removeWhere((c) => c.id == id);
    await _saveToStorage(_categoriesKey, categories);
  }
}
