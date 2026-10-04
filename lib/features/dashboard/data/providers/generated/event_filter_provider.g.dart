// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventFilterNotifier)
final eventFilterProvider = EventFilterNotifierProvider._();

final class EventFilterNotifierProvider
    extends $NotifierProvider<EventFilterNotifier, EventFilterState> {
  EventFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventFilterNotifierHash();

  @$internal
  @override
  EventFilterNotifier create() => EventFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventFilterState>(value),
    );
  }
}

String _$eventFilterNotifierHash() =>
    r'2a072933c08737962d95779a98ec95be0f35a7c5';

abstract class _$EventFilterNotifier extends $Notifier<EventFilterState> {
  EventFilterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EventFilterState, EventFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventFilterState, EventFilterState>,
              EventFilterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Synchronous filtered events provider
/// Returns filtered list instantly without async loading states

@ProviderFor(filteredEvents)
final filteredEventsProvider = FilteredEventsProvider._();

/// Synchronous filtered events provider
/// Returns filtered list instantly without async loading states

final class FilteredEventsProvider
    extends
        $FunctionalProvider<
          List<EventModel>,
          List<EventModel>,
          List<EventModel>
        >
    with $Provider<List<EventModel>> {
  /// Synchronous filtered events provider
  /// Returns filtered list instantly without async loading states
  FilteredEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredEventsHash();

  @$internal
  @override
  $ProviderElement<List<EventModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EventModel> create(Ref ref) {
    return filteredEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$filteredEventsHash() => r'211c185055ff0b3dc0ee10e1935cb2e08587e17b';
