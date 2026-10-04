// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../price.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PricesNotifier)
final pricesProvider = PricesNotifierProvider._();

final class PricesNotifierProvider
    extends $AsyncNotifierProvider<PricesNotifier, PriceResponse> {
  PricesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pricesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pricesNotifierHash();

  @$internal
  @override
  PricesNotifier create() => PricesNotifier();
}

String _$pricesNotifierHash() => r'4e211dfe3cce68da18ea73d3b870f6d0aa1dc3fd';

abstract class _$PricesNotifier extends $AsyncNotifier<PriceResponse> {
  FutureOr<PriceResponse> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PriceResponse>, PriceResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PriceResponse>, PriceResponse>,
              AsyncValue<PriceResponse>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
