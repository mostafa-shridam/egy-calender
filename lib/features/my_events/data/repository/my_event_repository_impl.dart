import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/enums/constants_enums.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/supabase.dart';
import '../models/my_event.dart';
import '../providers/local_my_events.dart';
import 'my_event_repository.dart';

class MyEventRepositoryImpl implements MyEventsRepository {
  static final MyEventRepositoryImpl _instance = MyEventRepositoryImpl._();
  static MyEventRepositoryImpl get instance => _instance;
  MyEventRepositoryImpl._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalMyEvents _local = LocalMyEvents.instance;
  final NetworkService _network = NetworkService.instance;
  final SupabaseService _storage = SupabaseService.instance;

  Future<bool> get _isOnline async =>
      await _network.checkStatus() == NetworkStatus.online;
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
  bool get _isGuest => _currentUserId.isEmpty;

  CollectionReference<Map<String, dynamic>> get _remoteColl => _firestore
      .collection(Constants.users.name)
      .doc(_currentUserId)
      .collection(Constants.myEvents.name);

  @override
  Future<List<MyEvent>> getEvents() async {
    final localData = await _local.getEvents();
    if (!_isGuest && await _isOnline) _syncRemoteEvents();
    return localData;
  }

  Future<void> _syncRemoteEvents() async {
    try {
      final snapshot = await _remoteColl.get();
      final remoteData =
          snapshot.docs.map((doc) => MyEvent.fromJson(doc.data())).toList();
      final localIds = (await _local.getEvents()).map((e) => e.id).toSet();

      for (var item in remoteData) {
        item.isSynced = true;
        if (!localIds.contains(item.id)) {
          await _local.addEvent(item);
        } else {
          await _local.updateEvent(
            item,
          ); // تأكد إن الميثود دي في الـ Local Provider
        }
      }
    } catch (e) {
      log('Event Sync Error: $e');
    }
  }

  @override
  Future<void> addEvent(MyEvent event) async {
    event.id ??= const Uuid().v4();
    event.isSynced = false;
    await _local.addEvent(event);
    if (!_isGuest && await _isOnline) _uploadEventInBackground(event);
  }

  Future<void> _uploadEventInBackground(MyEvent event) async {
    try {
      if (event.image != null && !event.image!.startsWith('http')) {
        final url = await _storage.uploadImage(
          file: Uint8List.fromList(event.image!.codeUnits),
        );
        if (url != null) event.image = url;
      }
      await _remoteColl.doc(event.id).set(event.toJson());
      event.isSynced = true;
      await _local.updateEvent(event);
    } catch (e) {
      log('Upload Error: $e');
    }
  }

  @override
  Future<void> updateEvent(MyEvent event) async {
    event.isSynced = false;
    await _local.updateEvent(event);
    if (!_isGuest && await _isOnline) {
      await _remoteColl.doc(event.id).update(event.toJson());
      event.isSynced = true;
      await _local.updateEvent(event);
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _local.deleteEvent(id);
    if (!_isGuest && await _isOnline) await _remoteColl.doc(id).delete();
  }

  @override
  Future<void> migrateGuestData() async {
    if (!await _isOnline) return;

    final localData = await _local.getEvents();
    if (localData.isEmpty) return;

    final batch = _firestore.batch();
    final newColl = _firestore
        .collection(Constants.users.name)
        .doc(_currentUserId)
        .collection(Constants.myEvents.name);
    for (var item in localData) {
      batch.set(newColl.doc(item.id), item.toJson());
    }
    await batch.commit();

    for (var item in localData) {
      item.isSynced = true;
      await _local.updateEvent(item);
    }
  }

  @override
  Stream<MyEvent> streamEvent(String id) => _remoteColl
      .doc(id)
      .snapshots()
      .map((snap) => MyEvent.fromJson(snap.data()!));
}
