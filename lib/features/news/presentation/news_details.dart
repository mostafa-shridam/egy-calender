import 'dart:developer';

import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/core/widgets/sliver_bar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/features/news/data/models/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/constants.dart';
import '../data/providers/news.dart';

class NewsDetailspage extends ConsumerWidget {
  final String newsId;
  static const String routeName = '/news_details';
  const NewsDetailspage({super.key, required this.newsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(newsProvider.select((e) => e.isLoading));
    final theme = Theme.of(context);
    log('📰 Building NewsDetailspage for newsId: $newsId');
    final news =
        ref.watch(
          newsProvider.select(
            (state) => state.value?.news?.data?.firstWhereOrNull(
              (element) => element.id == newsId,
            ),
          ),
        ) ??
        NewsModel();
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  CustomSliverAppBar(imageUrl: news.imageUrl ?? ''),
                  SliverToBoxAdapter(
                    child: Container(
                      transform: Matrix4.translationValues(
                        0,
                        -30,
                        0,
                      ), // حركة لرفع الكارت فوق الصورة
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // المصدر كـ Tag
                          const SizedBox(height: 16),
                          if (dataIsNotEmpty(data: news.sourceName(context)))
                            _buildSourceChip(context, news: news),

                          const SizedBox(height: 16),

                          // العنوان (التركيز الأساسي)
                          if (dataIsNotEmpty(data: news.title(context)))
                            Text(
                              news.title(context)!,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.4,
                                letterSpacing: -0.5,
                              ),
                            ),

                          const SizedBox(height: 20),

                          // شريط المعلومات (التاريخ والكاتب)
                          if (dataIsNotEmpty(data: news.publishedAt) ||
                              dataIsNotEmpty(data: news.author))
                            _buildMetaBar(context, news),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Divider(thickness: 1),
                          ),

                          // الوصف المختصر (Lead Section)
                          if (dataIsNotEmpty(data: news.description(context)))
                            Container(
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: theme.primaryColor,
                                    width: 4,
                                  ),
                                ),
                              ),
                              child: Text(
                                news.description(context)!,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withValues(alpha: 0.8),
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // المحتوى الأساسي
                          if (dataIsNotEmpty(data: news.content(context)))
                            Text(
                              news.content(context)!,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.8,
                                fontSize: 17,
                                color: theme.textTheme.bodyLarge?.color
                                    ?.withValues(alpha: 0.9),
                              ),
                            ),

                          const SizedBox(height: 40),

                          // زر القراءة من المصدر بستايل مميز
                          if (dataIsNotEmpty(data: news.newsUrl))
                            CustomButton(
                              text: 'Read full articale!',
                              onPressed: () => myLaunchURL(news.newsUrl!),
                            ),

                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildSourceChip(BuildContext context, {required NewsModel news}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dataIsNotEmpty(data: news.sourceLogo))
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(news.sourceLogo!),
              ),
            ),
          Text(
            news.sourceName(context)!,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaBar(BuildContext context, NewsModel news) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 6),
          if (dataIsNotEmpty(data: news.publishedAt))
            Text(
              formatDateTime(
                news.publishedAt!,
                context,
                format: dateOnlyFormat,
              ),
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),

          if (dataIsNotEmpty(data: news.author)) ...[
            const Spacer(),
            Icon(
              Icons.person_outline_rounded,
              size: 16,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Text(
              news.author!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
