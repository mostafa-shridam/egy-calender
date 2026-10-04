import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/enums/constants_enums.dart';
import '../../../../core/network/network_service.dart';
import '../models/my_category.dart';
import '../providers/local_my_events.dart';
import 'my_category_repo.dart';

class MyCategoryRepoImpl implements MyCategoryRepo {
  static final MyCategoryRepoImpl _instance = MyCategoryRepoImpl._();
  static MyCategoryRepoImpl get instance => _instance;
  MyCategoryRepoImpl._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalMyEvents _local = LocalMyEvents.instance;
  final NetworkService _network = NetworkService.instance;

  Future<bool> get _isOnline async =>
      await _network.checkStatus() == NetworkStatus.online;
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
  bool get _isGuest => _currentUserId.isEmpty;

  CollectionReference<Map<String, dynamic>> get _remoteColl => _firestore
      .collection(Constants.users.name)
      .doc(_currentUserId)
      .collection(Constants.myCategories.name);

  @override
  Future<List<MyCategory>> getCategories() async {
    final localData = await _local.getCategories();
    if (!_isGuest && await _isOnline) _syncRemoteToLocal();
    return localData;
  }

  Future<void> _syncRemoteToLocal() async {
    try {
      final snapshot = await _remoteColl.get();
      final remoteData =
          snapshot.docs.map((doc) => MyCategory.fromJson(doc.data())).toList();
      final localIds = (await _local.getCategories()).map((e) => e.id).toSet();

      for (var item in remoteData) {
        item.isSynced = true;
        if (!localIds.contains(item.id)) {
          await _local.addCategory(item);
        } else {
          await _local.updateCategory(item);
        }
      }
    } catch (e) {
      log('Category Sync Error: $e');
    }
  }

  @override
  Future<void> addCategory(MyCategory category) async {
    category.id ??= const Uuid().v4();
    category.isSynced = false;
    await _local.addCategory(category);

    if (!_isGuest && await _isOnline) {
      await _remoteColl.doc(category.id).set(category.toJson());
      category.isSynced = true;
      await _local.updateCategory(category);
    }
  }

  @override
  Future<void> updateCategory(MyCategory category) async {
    category.isSynced = false;
    await _local.updateCategory(category);
    if (!_isGuest && await _isOnline) {
      await _remoteColl.doc(category.id).update(category.toJson());
      category.isSynced = true;
      await _local.updateCategory(category);
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _local.deleteCategory(id);
    if (!_isGuest && await _isOnline) await _remoteColl.doc(id).delete();
  }

  @override
  Future<void> migrateGuestData() async {
    if (!await _isOnline) return;
    final localData = await _local.getCategories();
    if (localData.isEmpty) return;

    final batch = _firestore.batch();
    final newColl = _firestore
        .collection(Constants.users.name)
        .doc(_currentUserId)
        .collection(Constants.myCategories.name);

    for (var item in localData) {
      batch.set(newColl.doc(item.id), item.toJson());
    }
    await batch.commit();

    for (var item in localData) {
      item.isSynced = true;
      await _local.updateCategory(item);
    }
  }
}
