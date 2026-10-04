/// Base exception for Firestore operations
class FirestoreException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  FirestoreException({required this.message, this.code, this.originalError});

  @override
  String toString() =>
      'FirestoreException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when a user is not found
class UserNotFoundException extends FirestoreException {
  UserNotFoundException({String? userId})
    : super(
        message: 'User not found${userId != null ? ' with ID: $userId' : ''}',
        code: 'user-not-found',
      );
}

/// Exception thrown when attempting to create a user that already exists
class UserAlreadyExistsException extends FirestoreException {
  UserAlreadyExistsException({String? userId})
    : super(
        message:
            'User already exists${userId != null ? ' with ID: $userId' : ''}',
        code: 'user-already-exists',
      );
}

/// Exception thrown when a Firestore operation fails
class FirestoreOperationException extends FirestoreException {
  FirestoreOperationException({
    required super.message,
    super.code,
    super.originalError,
  });
}
