import 'dart:convert';
import 'dart:developer';

import '../../config/secrets.dart';
import '../../enums/constants_enums.dart';
import '../../local_services/local_storage.dart';
import '../../remote_services/api_result.dart';
import '../../remote_services/api_service.dart';
import '../../remote_services/dio_client.dart';
import '../../../features/events/data/models/event_category.dart';
import '../../../features/events/data/models/event_model.dart';
import '../../../features/events/data/models/event_section.dart';
import 'event_repo.dart';

class EventsRepoImpl implements EventRepo {
  final ApiService apiService = ApiService(DioClient(baseUrl: Secrets.baseUrl));
  final DioClient dioClient = DioClient(baseUrl: Secrets.baseUrl);
  final LocalStorage _storage = LocalStorage.instance;
  // get events
  @override
  Future<List<EventModel>> getEvents() async {
    try {
      final result = await apiService.get<List<EventModel>>(
        '${Secrets.baseUrl}/Events',
        fromJson: (data) {
          if (data is Map && data.containsKey(r'$values')) {
            final List listData = data[r'$values'];
            return listData.map((e) => EventModel.fromJson(e)).toList();
          }
          return [];
        },
      );

      if (result is Success<List<EventModel>>) {
        await _storage.add(
          Constants.events.name,
          jsonEncode(result.data.map((e) => e.toJson(toLocale: true)).toList()),
        );
        log('Events fetched successfully');
        return result.data;
      } else {
        throw Exception('Failed to load events: ${(result as Failure).error}');
      }
    } catch (e) {
      log('Error fetching events: $e');
      throw Exception('Error fetching events: $e');
    }
  }

  //add event
  @override
  Future<void> addEvent(EventModel event) async {
    try {
      final result = await apiService.post<EventModel>(
        '${Secrets.baseUrl}/Events',
        event.toJson(),
        fromJson: (data) => _parseSingleEvent(data),
      );
      if (result is Success<EventModel>) {
        
        return;
      } else {
        throw Exception('Failed to add event: ${(result as Failure).error}');
      }
    } catch (e) {
      log('Error adding event: $e');
      throw Exception('Error adding event: $e');
    }
  }

  //update event
  @override
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      final result = await apiService.put<EventModel>(
        '${Secrets.baseUrl}/Events/${event.id}',
        event.toJson(),
        fromJson: (data) => EventModel.fromJson(data),
      );
      if (result is Success<EventModel>) {
        return result.data;
      } else {
        throw Exception('Failed to update event: ${(result as Failure).error}');
      }
    } catch (e) {
      log('Error updating event: $e');
      throw Exception('Error updating event: $e');
    }
  }

  //delete event
  @override
  Future<EventModel> deleteEvent(String eventId) async {
    try {
      final result = await apiService.delete<EventModel>(
        '${Secrets.baseUrl}/Events/$eventId',
        eventId,
        fromJson: (data) => EventModel.fromJson(data),
      );
      if (result is Success<EventModel>) {
        return result.data;
      } else {
        throw Exception('Failed to update event: ${(result as Failure).error}');
      }
    } catch (e) {
      log('Error updating event: $e');
      throw Exception('Error updating event: $e');
    }
  }

  // get event by id
  @override
  Future<EventModel> getEventById(String eventId) async {
    try {
      final result = await apiService.get<EventModel>(
        '${Secrets.baseUrl}/Events/$eventId',
        fromJson: (data) => EventModel.fromJson(data['values']),
      );
      if (result is Success<EventModel>) {
        return result.data;
      } else {
        throw Exception('Failed to update event: ${(result as Failure).error}');
      }
    } catch (e) {
      log('Error updating event: $e');
      throw Exception('Error updating event: $e');
    }
  }

  EventModel _parseSingleEvent(dynamic data) {
    if (data is Map<String, dynamic>) {
      // في بعض إعدادات ASP.NET بيرجع $values
      if (data.containsKey(r'$values') && data[r'$values'] is List) {
        return EventModel.fromJson(data[r'$values'][0]);
      }
      return EventModel.fromJson(data);
    }
    throw Exception("Invalid Data Format");
  }

  //get categories
  @override
  Future<List<EventCategory>> getCategories() async {
    try {
      final result = await apiService.get<List<EventCategory>>(
        '${Secrets.baseUrl}/EventCategories',
        fromJson: (data) {
          // السيرفر بيرجع الـ Categories جوه $values
          if (data is Map && data.containsKey(r'$values')) {
            final List listData = data[r'$values'];
            final categories =
                listData.map((e) => EventCategory.fromJson(e)).toList();

            return categories;
          }
          return [];
        },
      );

      if (result is Success<List<EventCategory>>) {
        log('Categories fetched: ${result.data.length}');
        _storage.add(
          Constants.categories.name,
          jsonEncode(result.data.map((e) => e.toJson(withId: true)).toList()),
        );
        return result.data;
      } else {
        throw Exception('Failure: ${(result as Failure).error}');
      }
    } catch (e) {
      log('Critical Error: $e');
      throw Exception('Error: $e');
    }
  }

  // add category
  @override
  Future<EventCategory> addCategory(EventCategory category) async {
    try {
      final result = await apiService.post<EventCategory>(
        '${Secrets.baseUrl}/EventCategories',
        category.toJson(),
        fromJson: (data) => _parseSingleCategory(data),
      );

      if (result is Success<EventCategory>) {
        return result.data;
      } else {
        throw Exception('Failed to add category');
      }
    } catch (e) {
      log('Error adding category: $e');
      rethrow;
    }
  }

  // update category
  @override
  Future<EventCategory> updateCategory(EventCategory category) async {
    try {
      log('updating category id : ${category.id}');
      final result = await apiService.put<EventCategory>(
        '${Secrets.baseUrl}/EventCategories/${category.id}',
        category.toJson(),
        fromJson: (data) => EventCategory.fromJson(data),
      );

      if (result is Success<EventCategory>) {
        return result.data;
      } else {
        final failure = result as Failure;
        throw failure.error;
      }
    } catch (e) {
      log('Error updating category: $e');
      rethrow;
    }
  }

  // delete category
  @override
  Future<EventCategory> deleteCategory(String categoryId) async {
    try {
      log('deleting category id : $categoryId');
      final result = await apiService.delete<EventCategory>(
        '${Secrets.baseUrl}/EventCategories/$categoryId',
        null, // ✅ DELETE بدون body
        fromJson: (data) => _parseSingleCategory(data),
      );

      if (result is Success<EventCategory>) {
        return result.data;
      } else {
        final failure = result as Failure;
        throw failure.error;
      }
    } catch (e) {
      log('Error deleting category: $e');
      rethrow;
    }
  }

  // helper method
  EventCategory _parseSingleCategory(dynamic data) {
    if (data is Map<String, dynamic>) {
      // في بعض إعدادات ASP.NET بيرجع $values
      if (data.containsKey(r'$values') && data[r'$values'] is List) {
        return EventCategory.fromJson(data[r'$values'][0]);
      }
      return EventCategory.fromJson(data);
    }
    throw Exception("Invalid Data Format");
  }

  //get sections
  @override
  Future<List<EventSection>> getSections() async {
    try {
      final result = await apiService.get<List<EventSection>>(
        '${Secrets.baseUrl}/EventSections',
        fromJson: (data) {
          if (data is Map && data.containsKey(r'$values')) {
            final List listData = data[r'$values'];
            return listData
                .map((e) => EventSection.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
      if (result is Success<List<EventSection>>) {
        log('Events fetched successfully: ${result.data.length} items');
        await _storage.add(
          Constants.sections.name,
          jsonEncode(result.data.map((e) => e.toJson(withId: true)).toList()),
        );
        return result.data;
      } else {
        log(
          'Error fetching sections with faliure : ${(result as Failure).error}',
        );

        throw Exception(
          'Failed to load sections: ${(result as Failure).error}',
        );
      }
    } catch (e) {
      log('Error fetching sections: $e, with faliure :');
      throw Exception('Error fetching sections: $e');
    }
  }

  //add section
  @override
  Future<EventSection> addSection(EventSection section) async {
    try {
      final result = await apiService.post<EventSection>(
        '${Secrets.baseUrl}/EventSections',
        section.toJson(),
        fromJson: (data) => _parseSingleSection(data),
      );
      if (result is Success<EventSection>) {
        return result.data;
      } else {
        throw Exception('Failed to add section: ${(result as Failure).error}');
      }
    } catch (e) {
      log('Error adding section: $e');
      throw Exception('Error adding section: $e');
    }
  }

  //update section
  @override
  Future<EventSection> updateSection(EventSection section) async {
    try {
      final result = await apiService.put<EventSection>(
        '${Secrets.baseUrl}/EventSections/${section.id}',
        section.toJson(),
        fromJson: (data) => EventSection.fromJson(data),
      );
      if (result is Success<EventSection>) {
        return result.data;
      } else {
        throw Exception(
          'Failed to update section: ${(result as Failure).error}',
        );
      }
    } catch (e) {
      log('Error updating section: $e');
      throw Exception('Error updating section: $e');
    }
  }

  //delete section
  @override
  Future<EventSection> deleteSection(String sectionId) async {
    try {
      final result = await apiService.delete<EventSection>(
        '${Secrets.baseUrl}/EventSections/$sectionId',
        null,
        fromJson: (data) => EventSection.fromJson(data),
      );
      if (result is Success<EventSection>) {
        return result.data;
      } else {
        throw Exception(
          'Failed to delete section: ${(result as Failure).error}',
        );
      }
    } catch (e) {
      log('Error deleting section: $e');
      throw Exception('Error deleting section: $e');
    }
  }

  EventSection _parseSingleSection(dynamic data) {
    if (data is Map<String, dynamic>) {
      // في بعض إعدادات ASP.NET بيرجع $values
      if (data.containsKey(r'$values') && data[r'$values'] is List) {
        return EventSection.fromJson(data[r'$values'][0]);
      }
      return EventSection.fromJson(data);
    }
    throw Exception("Invalid Data Format");
  }
}
