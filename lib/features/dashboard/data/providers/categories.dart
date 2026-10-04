import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/repositories/events/event_repo.dart';
import '../../../../core/repositories/events/events_repo_impl.dart';
import '../../../events/data/models/event_category.dart';
import '../../../settings/data/models/version.dart';
import 'settings.dart';
part 'generated/categories.g.dart';

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  final EventRepo eventRepo = EventsRepoImpl();
  @override
  Future<List<EventCategory>> build() async {
    try {
      return await eventRepo.getCategories();
    } catch (e) {
      return [];
    }
  }

  Future<void> addCategory(EventCategory category) async {
    try {
      // log('Start to add new category ${category.toJson()}');

      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        await eventRepo.addCategory(category);
        await _updateVersion();

        return await eventRepo.getCategories();
      });
    } catch (e) {
      // log('Failed to add new category ${category.toJson()} with error: $e');
    }
  }

  Future<void> updateCategory(EventCategory category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await eventRepo.updateCategory(category);
      await _updateVersion();

      return await eventRepo.getCategories();
    });
  }

  Future<void> deleteCategory(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await eventRepo.deleteCategory(id);
      await _updateVersion();

      return await eventRepo.getCategories();
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
