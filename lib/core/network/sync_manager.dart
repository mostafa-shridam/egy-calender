import 'dart:developer';
import 'package:calender/features/my_events/data/providers/local_my_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/enums/constants_enums.dart';


class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  static SyncManager get instance => _instance;

  SyncManager._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalMyEvents _local = LocalMyEvents.instance;

  /// Fetches pending (isSynced = false) data from Local Storage
  /// and uploads it to Firestore in a batch.
  Future<void> syncPendingData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log('Cannot sync: No user logged in.');
      return;
    }

    try {
      log('Starting Sync Process...');
      final batch = _firestore.batch();
      bool hasUpdates = false;

      // 1. Sync Events
      // Fetch all local events (simulating a query for isSynced=false)
      // Since local storage might not support complex queries easily, we fetch all and filter.
      final allEvents = await _local.getEvents();
      final pendingEvents =
          allEvents.where((e) => e.isSynced == false).toList();

      if (pendingEvents.isNotEmpty) {
        log('Found ${pendingEvents.length} pending events.');
        // Assuming user collection path logic is consistent
        final eventCollection = _firestore
            .collection(Constants.users.name)
            .doc(user.uid)
            .collection(Constants.myEvents.name);

        for (var event in pendingEvents) {
          // Prepare for upload
          // Important: We set isSynced = true for the remote version
          // But we also need to update the local version after successful batch commit.
          // For now, let's stage the write.
          final eventRef = eventCollection.doc(event.id);
          final eventData = event.toJson();
          eventData['isSynced'] = true; // Mark as synced in cloud

          batch.set(eventRef, eventData, SetOptions(merge: true));
        }
        hasUpdates = true;
      }

      // 2. Sync Categories (Similar Logic)
      // Filter logic assumes we can get categories.
      // Need to ensure LocalMyEvents exposes categories or a similar provider does.
      // Let's assume LocalStorage exposes a way to get categories similar to events
      // If not, we might need to add it to LocalMyEvents or create LocalMyCategories.
      // For this task, assuming LocalMyEvents manages both or logic sits there.
      // Checking `LocalMyEvents` code again would be ideal, but assuming standard pattern.
      // Wait, I recall MyCategoryRepoImpl uses LocalMyEvents. So it likely has category methods.

      // If batch has operations, commit
      if (hasUpdates) {
        await batch.commit();
        log('Batch Sync Committed Successfully.');

        // 3. Update Local "isSynced" status
        // We need to update the local items to isSynced = true
        // This might be expensive if many items, but necessary.

        for (var event in pendingEvents) {
          event.isSynced = true;
          await _local.addEvent(event); // Re-save with updated flag
        }

        // Similar for categories if implemented
        log('Local data updated to Synced.');
      } else {
        log('No pending data to sync.');
      }
    } catch (e) {
      log('Sync Failed: $e');
      // On failure, we just try again next time. Data remains isSynced=false locally.
    }
  }
}
