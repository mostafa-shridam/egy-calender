import 'dart:math';

import 'package:calender/features/dashboard/data/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/repositories/events/event_repo.dart';
import '../../../../core/repositories/events/events_repo_impl.dart';
import '../../../events/data/models/event_model.dart';
import '../../../settings/data/models/version.dart';
part 'generated/events.g.dart';

@riverpod
class EventsNotifier extends _$EventsNotifier {
  final EventRepo eventRepo = EventsRepoImpl();
  @override
  Future<List<EventModel>> build() async {
    final events = await eventRepo.getEvents();
    events.sort((a, b) {
      if (a.createdAt == null || b.createdAt == null) {
        return 0;
      }
      return b.createdAt!.compareTo(a.createdAt!);
    });
    return events;
  }

  Future<void> addEvent(EventModel event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await eventRepo.addEvent(event);
      await _updateVersion();

      return await eventRepo.getEvents();
    });
  }

  Future<void> updateEvent(EventModel event) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await eventRepo.updateEvent(event);
      await _updateVersion();

      return await eventRepo.getEvents();
    });
  }

  Future<void> deleteEvent(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await eventRepo.deleteEvent(id);
      await _updateVersion();

      return await eventRepo.getEvents();
    });
  }

  Future<void> _updateVersion() async {
    ref
        .watch(settingsProvider.notifier)
        .updateVersion(
          VersionModel(id: '2', version: Random().nextInt(10000).toString()),
        );
  }
}
