import '../models/my_event.dart';

/// Abstract repository interface for user operations
abstract class MyEventsRepository {
  /// Add a new user to Firestore
  /// Throws [UserAlreadyExistsException] if user with same ID exists
  /// Throws [FirestoreOperationException] for other errors
  Future<void> addEvent(MyEvent event);

  /// Update an existing user in Firestore
  /// Throws [UserNotFoundException] if user doesn't exist
  /// Throws [FirestoreOperationException] for other errors
  Future<void> updateEvent(MyEvent user);

  /// Delete a user from Firestore
  /// Throws [UserNotFoundException] if user doesn't exist
  /// Throws [FirestoreOperationException] for other errors
  Future<void> deleteEvent(String eventId);

  /// Get all users from Firestore
  /// Throws [FirestoreOperationException] for errors
  Future<List<MyEvent>> getEvents();

  /// Stream user data in real-time
  /// Returns null if user doesn't exist
  /// Throws [FirestoreOperationException] for errors
  Stream<MyEvent?> streamEvent(String eventId);

  Future<void> migrateGuestData();
}
