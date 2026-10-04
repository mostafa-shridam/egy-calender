import 'dart:convert';
import 'dart:developer';

import 'package:calender/features/my_events/data/providers/my_events.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/constants_enums.dart';
import '../../../../core/local_services/local_storage.dart';
import '../../../../core/network/network_service.dart';
import '../../../dashboard/data/providers/categories.dart';
import '../../../dashboard/data/providers/sections.dart';
import '../../../dashboard/data/providers/events.dart' as dashboard;
import '../../../events/data/providers/events.dart';
import '../../../settings/data/models/version.dart';
import '../../../settings/data/providers/remote_settings.dart';

part 'generated/initial_data_provider.g.dart';

@riverpod
class InitialDataLoader extends _$InitialDataLoader {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> init() async {
    ref.keepAlive();
    try {
      final eventsNotifier = ref.watch(eventsProvider.notifier);
      final settingsNotifier = ref.watch(settingsServicesProvider.notifier);
      await ref.watch(myEventsProvider.notifier).migrateGuestData();
      if (kIsWeb) {
        await Future.wait([
          ref.watch(dashboard.eventsProvider.future),
          ref.watch(categoriesProvider.future),
          ref.watch(sectionsProvider.future),
        ]);
        if (!ref.mounted) return;
        return;
      }

      final checker = VersionChecker(
        storage: LocalStorage.instance,
        settingsServices: settingsNotifier,
      );

      final updateEvents = await checker.shouldUpdateFromServer(
        '2',
        Constants.hashcodeEvents.name,
      );

      if (!ref.mounted) return;
      final updateSettings = await checker.shouldUpdateFromServer(
        '4',
        Constants.hashcodeSettings.name,
      );
      if (!ref.mounted) return;
      if (updateEvents) {
        await eventsNotifier.refresh();
        if (!ref.mounted) return;
      }

      if (updateSettings) {
        await settingsNotifier.getFromServer();
        if (!ref.mounted) return;
      }
    } catch (e, stack) {
      log('Error in InitialDataLoader: $e', stackTrace: stack);
    }
  }
}

class VersionChecker {
  final LocalStorage storage;
  final SettingsServices settingsServices;

  VersionChecker({required this.storage, required this.settingsServices});

  Future<bool> shouldUpdateFromServer(String id, String key) async {
    log('START — id=$id, key=$key');

    try {
      final networkStatus = await NetworkService.instance.checkStatus();
      log('Network status: $networkStatus');

      if (networkStatus != NetworkStatus.online) {
        log('Offline → skip');
        return false;
      }

      final rawLocalData = await storage.get(key);
      log('Raw local data for key $key: $rawLocalData');

      VersionModel? localVersion;
      if (rawLocalData != null && rawLocalData.isNotEmpty) {
        try {
          localVersion = VersionModel.fromJson(jsonDecode(rawLocalData));
          log('Local version for key $key: ${localVersion.version}');
        } catch (e) {
          log('Failed to parse local version for key $key: $e');
        }
      }

      final serverVersion = await settingsServices.getVersionInfo(id);

      log('Server version for key $key: ${serverVersion.version}');

      final shouldFetch =
          localVersion == null || localVersion.version != serverVersion.version;

      log('Should fetch for key $key: $shouldFetch');
      log(
        'cache version ${localVersion?.version} , server version ${serverVersion.version}',
      );
      if (shouldFetch) {
        await storage.add(
          key,
          jsonEncode(serverVersion.toJson(toLocale: true)),
        );
        log('[UpdateCheck] Local version updated');
      }

      log('[UpdateCheck] END — result=$shouldFetch');
      return shouldFetch;
    } catch (e, stack) {
      log('[UpdateCheck] ERROR: $e', stackTrace: stack);
      return false;
    }
  }
}
