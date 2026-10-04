// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Events)
final eventsProvider = EventsProvider._();

final class EventsProvider extends $AsyncNotifierProvider<Events, EventStates> {
  EventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsHash();

  @$internal
  @override
  Events create() => Events();
}

String _$eventsHash() => r'83e3bfab90d46a0c9cfd6f2dbbf2f99ed1ff0bfd';

abstract class _$Events extends $AsyncNotifier<EventStates> {
  FutureOr<EventStates> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EventStates>, EventStates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EventStates>, EventStates>,
              AsyncValue<EventStates>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
