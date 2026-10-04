import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/widgets/general_loading_widget.dart';
import 'package:calender/features/news/data/providers/news.dart';
import 'package:calender/features/news/presentation/news_details.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/news_price_categories_widget.dart';
import '../../../core/widgets/news_price_widget.dart';

class NewsPage extends ConsumerWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsProvider);
    return RefreshIndicator.adaptive(
      onRefresh: () async => await ref.watch(newsProvider.notifier).refresh(),
      child: news.when(
        data: (newsData) {
          final categories = newsData.getAllCategories ?? [];
          return !dataIsNotEmpty(list: newsData.categories?.data) &&
                  !dataIsNotEmpty(list: newsData.news?.data)
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.errorPleaseTryAgain.tr()),
                    TextButton(
                      onPressed:
                          () => ref.watch(newsProvider.notifier).refresh(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    NewsPriceCategoriesWidget(
                      newsCategories: categories,
                      onCategoryTap: (id) {
                        ref.watch(newsProvider.notifier).filterByCategory(id);
                      },
                      selectedCategoryId: newsData.selectedCategoryId,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: newsData.filterNews?.length ?? 0,
                        itemBuilder: (context, index) {
                          final data = newsData.filterNews?[index];
                          final color =
                              categories
                                  .firstWhereOrNull(
                                    (element) => element.id == data?.categoryId,
                                  )
                                  ?.color ??
                              AppColors.primaryColor.toARGB32();
                          return NewsPriceWidget(
                            date: data?.publishedAt ?? '',
                            title: data?.title(context) ?? '',
                            description: data?.description(context) ?? '',
                            imageUrl: data?.imageUrl ?? '',
                            color: color,
                            onTap:
                                () => context.pushNamed(
                                  NewsDetailspage.routeName,
                                  pathParameters: {'id': data?.id ?? ''},
                                ),
                          );
                        },
                      ),
                    ),
                  ],
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
