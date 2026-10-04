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

String _$newsNotifierHash() => r'0fd4b35d78c8226ec7048b487df1f4a72858ff1b';

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
