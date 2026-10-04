// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../initial_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InitialDataLoader)
final initialDataLoaderProvider = InitialDataLoaderProvider._();

final class InitialDataLoaderProvider
    extends $AsyncNotifierProvider<InitialDataLoader, void> {
  InitialDataLoaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialDataLoaderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialDataLoaderHash();

  @$internal
  @override
  InitialDataLoader create() => InitialDataLoader();
}

String _$initialDataLoaderHash() => r'daaa5a5875e893cdd56098df0a9fb07dddb2f7fd';

abstract class _$InitialDataLoader extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
