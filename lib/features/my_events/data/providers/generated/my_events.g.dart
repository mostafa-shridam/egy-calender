// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../my_events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyEvents)
final myEventsProvider = MyEventsProvider._();

final class MyEventsProvider
    extends $AsyncNotifierProvider<MyEvents, MyEventsState> {
  MyEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myEventsHash();

  @$internal
  @override
  MyEvents create() => MyEvents();
}

String _$myEventsHash() => r'a09b20b2d585f5d1f05e30dfede0b1afb222c7fa';

abstract class _$MyEvents extends $AsyncNotifier<MyEventsState> {
  FutureOr<MyEventsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MyEventsState>, MyEventsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MyEventsState>, MyEventsState>,
              AsyncValue<MyEventsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
