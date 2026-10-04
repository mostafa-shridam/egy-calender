import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/enums/constants_enums.dart';
import '../../../../core/exceptions/firestore_exceptions.dart';
import '../models/user_model.dart';
import '../providers/save_user.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  static final UserRepositoryImpl _singelton = UserRepositoryImpl._();
  static UserRepositoryImpl get instance => _singelton;

  UserRepositoryImpl._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SaveUser _saveUser = SaveUser.instance;
  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection(
    kIsWeb ? Constants.webUsers.name : Constants.users.name,
  );
  @override
  Future<void> addUser(UserModel user) async {
    try {
      final docRef = _users.doc(user.id);
      final doc = await docRef.get();

      if (!doc.exists) {
        log('user not exists');
        await docRef.set(user.toJson());
        await _saveUser.saveUser(jsonEncode(user.toJson()));
      } else {
        await _saveUser.saveUser(jsonEncode(doc.data() ?? {}));
      }
    } catch (e) {
      log('Error adding user: $e');
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _users.doc(user.id).update(user.toJson());
      await _saveUser.saveUser(jsonEncode(user.toJson()));
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    log('start delete user');
    try {
      await _users.doc(userId).delete();
      await _saveUser.deleteUserData();
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final doc = await _users.doc(userId).get();
      final user = UserModel.fromJson(doc.data() ?? {});
      await _saveUser.saveUser(jsonEncode(user.toJson()));
      return user;
    } catch (e) {
      throw FirestoreOperationException(message: e.toString());
    }
  }

  @override
  Stream<UserModel?> streamUser(String userId) {
    try {
      return _users.doc(userId).snapshots().asyncMap((doc) async {
        if (!doc.exists) return null;

        final user = UserModel.fromJson(doc.data() ?? {});
        await _saveUser.saveUser(jsonEncode(user.toJson()));
        return user;
      });
    } catch (e) {
      throw FirestoreOperationException(message: "Stream user failed: $e");
    }
  }
}
