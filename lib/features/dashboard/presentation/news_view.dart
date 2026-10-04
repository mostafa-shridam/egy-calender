import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../news/data/models/news_model.dart';
import '../../../core/widgets/news_price_categories_widget.dart';
import '../data/providers/news.dart';
import 'universal_ai_proccessor.dart';
import 'widgets/forms/news_form.dart';
import 'widgets/universal_card.dart';

class NewsView extends ConsumerWidget with AlertMixin {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsProvider);
    return news.when(
      data: (newsData) {
        return Column(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: CustomButton(
                    text: 'Add News',
                    onPressed: () => _showForm(context, ref),
                  ),
                ),
                const SizedBox(width: 16),
                CustomButton(
                  width: 200,

                  text: 'Add News With Ai',
                  onPressed:
                      () => context.pushNamed(
                        UniversalAIProcessor.routeName,
                        extra: {
                          'type': AIType.news,
                          'categories': newsData.getAllCategories,
                        },
                      ),
                ),
              ],
            ),
            NewsPriceCategoriesWidget(
              newsCategories: newsData.getAllCategories,
              onCategoryTap: (id) {
                ref.read(newsProvider.notifier).filterNews(id);
              },
              selectedCategoryId: news.value?.selectedCategoryId ?? '0',
            ),
            const SizedBox(height: 8),
            if (dataIsNotEmpty(list: news.value?.news?.data))
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: List.generate(news.value!.news!.data!.length, (
                        index,
                      ) {
                        final newsData = news.value!.news!.data![index];
                        return UniversalCard(
                          showSelection: false,
                          index: index,
                          news: newsData,
                          isSelected: false,
                          isLoading: false,
                          onSelect: null,
                          onDelete:
                              () => _confirmDelete(
                                context,
                                ref,
                                newsData.id ?? '',
                              ),
                          onUpload: null,
                          onEdit: () => _showForm(context, ref, news: newsData),
                        );
                      }),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {NewsModel? news}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SizedBox(
              width: 400,
              child: NewsForm(
                news: news,
                onSave: (newNews) {
                  if (news == null) {
                    ref.read(newsProvider.notifier).addNews(newNews);
                  } else {
                    ref.read(newsProvider.notifier).updateNews(newNews);
                  }
                },
              ),
            ),
          ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDangerAlert(
      context: context,
      title: 'Delete News',
      message: 'Are you sure you want to delete this news?',
      onConfirm: () {
        ref.read(newsProvider.notifier).deleteNews(id);
      },
    );
  }
}
