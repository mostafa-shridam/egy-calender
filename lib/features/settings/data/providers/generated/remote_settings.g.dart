// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../remote_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsServices)
final settingsServicesProvider = SettingsServicesProvider._();

final class SettingsServicesProvider
    extends $AsyncNotifierProvider<SettingsServices, SettingsServicesStates> {
  SettingsServicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsServicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsServicesHash();

  @$internal
  @override
  SettingsServices create() => SettingsServices();
}

String _$settingsServicesHash() => r'fa464484e1e2fbd64d3fa63f69f6cbfcde7b89a6';

abstract class _$SettingsServices
    extends $AsyncNotifier<SettingsServicesStates> {
  FutureOr<SettingsServicesStates> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<SettingsServicesStates>, SettingsServicesStates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SettingsServicesStates>,
                SettingsServicesStates
              >,
              AsyncValue<SettingsServicesStates>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
