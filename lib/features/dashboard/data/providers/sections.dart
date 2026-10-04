import 'dart:math';
import 'package:calender/features/events/data/models/event_section.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/repositories/events/event_repo.dart';
import '../../../../core/repositories/events/events_repo_impl.dart';
import '../../../settings/data/models/version.dart';
import 'settings.dart';

part 'generated/sections.g.dart';

@riverpod
class SectionsNotifier extends _$SectionsNotifier {
  final EventRepo eventRepo = EventsRepoImpl();
  @override
  Future<List<EventSection>> build() async {
    try {
      return await eventRepo.getSections();
    } catch (e) {
      return [];
    }
  }

  Future<void> addSection(EventSection section) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await eventRepo.addSection(section);
      await _updateVersion();

      return await eventRepo.getSections();
    });
  }

  Future<void> updateSection(EventSection section) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await eventRepo.updateSection(section);
      await _updateVersion();

      return await eventRepo.getSections();
    });
  }

  Future<void> deleteSection(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await eventRepo.deleteSection(id);
      await _updateVersion();

      return await eventRepo.getSections();
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
