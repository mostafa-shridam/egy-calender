import '../models/user_model.dart';

/// Abstract repository interface for user operations
abstract class UserRepository {
  /// Add a new user to Firestore
  /// Throws [UserAlreadyExistsException] if user with same ID exists
  /// Throws [FirestoreOperationException] for other errors
  Future<void> addUser(UserModel user);

  /// Update an existing user in Firestore
  /// Throws [UserNotFoundException] if user doesn't exist
  /// Throws [FirestoreOperationException] for other errors
  Future<void> updateUser(UserModel user);

  /// Delete a user from Firestore
  /// Throws [UserNotFoundException] if user doesn't exist
  /// Throws [FirestoreOperationException] for other errors
  Future<void> deleteUser(String userId);

  /// Get a user by ID
  /// Returns null if user doesn't exist
  /// Throws [FirestoreOperationException] for errors
  Future<UserModel?> getUserById(String userId);

  /// Stream user data in real-time
  /// Returns null if user doesn't exist
  /// Throws [FirestoreOperationException] for errors
  Stream<UserModel?> streamUser(String userId);
}
