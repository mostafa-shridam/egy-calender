import '../../../features/events/data/models/event_category.dart';
import '../../../features/events/data/models/event_model.dart';
import '../../../features/events/data/models/event_section.dart';

abstract class EventRepo {
  //Events
  Future<List<EventModel>> getEvents();
  Future<EventModel> getEventById(String eventId);
  Future<void> addEvent(EventModel event);
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventId);

  //Categories
  Future<List<EventCategory>> getCategories();
  Future<void> addCategory(EventCategory event);
  Future<void> updateCategory(EventCategory event);
  Future<void> deleteCategory(String categoryId);

  //Sections
  Future<List<EventSection>> getSections();
  Future<void> addSection(EventSection event);
  Future<void> updateSection(EventSection event);
  Future<void> deleteSection(String sectionId);
}
