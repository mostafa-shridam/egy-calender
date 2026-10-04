// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../sections.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SectionsNotifier)
final sectionsProvider = SectionsNotifierProvider._();

final class SectionsNotifierProvider
    extends $AsyncNotifierProvider<SectionsNotifier, List<EventSection>> {
  SectionsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sectionsNotifierHash();

  @$internal
  @override
  SectionsNotifier create() => SectionsNotifier();
}

String _$sectionsNotifierHash() => r'51741e6a01d753441ee1b3b8bc64fb554012805e';

abstract class _$SectionsNotifier extends $AsyncNotifier<List<EventSection>> {
  FutureOr<List<EventSection>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<EventSection>>, List<EventSection>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<EventSection>>, List<EventSection>>,
              AsyncValue<List<EventSection>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
