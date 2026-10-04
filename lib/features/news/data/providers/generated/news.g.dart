// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../news.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewsNotifier)
final newsProvider = NewsNotifierProvider._();

final class NewsNotifierProvider
    extends $AsyncNotifierProvider<NewsNotifier, NewsStates> {
  NewsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsNotifierHash();

  @$internal
  @override
  NewsNotifier create() => NewsNotifier();
}

String _$newsNotifierHash() => r'8a488a3eec3a55eca7c8e2f604ebf0cff9da0ca1';

abstract class _$NewsNotifier extends $AsyncNotifier<NewsStates> {
  FutureOr<NewsStates> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<NewsStates>, NewsStates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NewsStates>, NewsStates>,
              AsyncValue<NewsStates>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
