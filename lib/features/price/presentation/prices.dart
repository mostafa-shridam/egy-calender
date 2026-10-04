import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/widgets/general_loading_widget.dart';
import 'package:calender/features/price/data/providers/price.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/news_price_widget.dart';
import 'price_details.dart';

class PricePage extends ConsumerWidget {
  const PricePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = ref.watch(pricesProvider);
    return RefreshIndicator.adaptive(
      onRefresh:
          () async => await ref.watch(pricesProvider.notifier).getPriceRemote(),
      child: prices.when(
        data: (priceData) {
          return !dataIsNotEmpty(list: priceData.data)
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.errorPleaseTryAgain.tr()),
                    TextButton(
                      onPressed:
                          () =>
                              ref
                                  .watch(pricesProvider.notifier)
                                  .getPriceRemote(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  itemCount: priceData.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final data = priceData.data?[index];
                    return NewsPriceWidget(
                      onTap:
                          () => context.pushNamed(
                            PriceDetailsPage.routeName,
                            pathParameters: {'id': data?.id ?? ''},
                          ),
                      color: 0xFF606c38,
                      date: data?.lastUpdate ?? '',
                      title: data?.title(context) ?? '',
                      description: data?.description(context) ?? '',
                      imageUrl: data?.imageUrl ?? '',
                    );
                  },
                ),
              );
        },
        error:
            (error, stackTrace) =>
                Center(child: Text(LocaleKeys.unkownError.tr())),
        loading: () => const GeneralLoadingWidget(),
      ),
    );
  }
}
