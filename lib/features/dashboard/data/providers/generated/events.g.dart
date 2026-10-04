// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventsNotifier)
final eventsProvider = EventsNotifierProvider._();

final class EventsNotifierProvider
    extends $AsyncNotifierProvider<EventsNotifier, List<EventModel>> {
  EventsNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$eventsNotifierHash();

  @$internal
  @override
  EventsNotifier create() => EventsNotifier();
}

String _$eventsNotifierHash() => r'be96dfa1d026db693045b708231667ac038a0f59';

abstract class _$EventsNotifier extends $AsyncNotifier<List<EventModel>> {
  FutureOr<List<EventModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<EventModel>>, List<EventModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<EventModel>>, List<EventModel>>,
              AsyncValue<List<EventModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
