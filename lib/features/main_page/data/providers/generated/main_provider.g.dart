// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../main_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MainProvider)
final mainProviderProvider = MainProviderProvider._();

final class MainProviderProvider
    extends $NotifierProvider<MainProvider, MainStates> {
  MainProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainProviderHash();

  @$internal
  @override
  MainProvider create() => MainProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MainStates value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MainStates>(value),
    );
  }
}

String _$mainProviderHash() => r'1256e78afcc6982b62bc8dec193ff947d9da7de1';

abstract class _$MainProvider extends $Notifier<MainStates> {
  MainStates build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MainStates, MainStates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MainStates, MainStates>,
              MainStates,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
