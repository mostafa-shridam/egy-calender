// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../categories.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoriesNotifier)
final categoriesProvider = CategoriesNotifierProvider._();

final class CategoriesNotifierProvider
    extends $AsyncNotifierProvider<CategoriesNotifier, List<EventCategory>> {
  CategoriesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesNotifierHash();

  @$internal
  @override
  CategoriesNotifier create() => CategoriesNotifier();
}

String _$categoriesNotifierHash() =>
    r'c018034904602c08525690181221df307d285f10';

abstract class _$CategoriesNotifier
    extends $AsyncNotifier<List<EventCategory>> {
  FutureOr<List<EventCategory>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<EventCategory>>, List<EventCategory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<EventCategory>>, List<EventCategory>>,
              AsyncValue<List<EventCategory>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
