import 'dart:developer';

import 'package:calender/core/constants/constants.dart';
import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/widgets/cached_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/sliver_bar.dart';
import '../data/models/price_model.dart';
import '../data/providers/price.dart';

class PriceDetailsPage extends ConsumerWidget {
  final String priceId;
  static const String routeName = '/price_details';

  const PriceDetailsPage({super.key, required this.priceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(pricesProvider.select((e) => e.isLoading));
    log('💲 Building PriceDetailsPage for priceId: $priceId');
    final priceItem =
        ref.watch(
          pricesProvider.select(
            (state) => state.value?.data?.firstWhereOrNull(
              (element) => element.id == priceId,
            ),
          ),
        ) ??
        PriceModel();
    final theme = Theme.of(context);
    return Scaffold(
      body: isLoading ? const Center(child: CircularProgressIndicator()) : CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(imageUrl: priceItem.imageUrl ?? ''),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (dataIsNotEmpty(data: priceItem.sourceName(context)))
                        _buildSourceChip(context, theme, priceItem),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // العنوان
                  if (dataIsNotEmpty(data: priceItem.title(context)))
                    Text(
                      priceItem.title(context)!,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),

                  const SizedBox(height: 24),

                  // كارت السعر الرئيسي (الجزء الأهم)
                  _buildPriceCard(theme, priceItem),

                  const SizedBox(height: 24),

                  // الوصف
                  if (dataIsNotEmpty(data: priceItem.description(context))) ...[
                    Text(
                      "Description", // تقدر تترجمها بـ Easy Localization
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      priceItem.description(context)!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.7,
                        color: theme.textTheme.bodyLarge?.color?.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),

                  // التحديث الأخير
                  if (dataIsNotEmpty(data: priceItem.lastUpdate))
                    _buildLastUpdateInfo(
                      theme,
                      priceItem.lastUpdate ?? '',
                      context,
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

  // --- Widgets البناء ---

  Widget _buildPriceCard(ThemeData theme, PriceModel priceItem) {
    // تحديد اللون بناءً على حالة التغير
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.remove;

    if (priceItem.changeStatus == 'up') {
      statusColor = Colors.green;
      statusIcon = Icons.trending_up;
    } else if (priceItem.changeStatus == 'down') {
      statusColor = Colors.red;
      statusIcon = Icons.trending_down;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Price",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${priceItem.currentPrice} EGP", // عدل العملة حسب الحاجة
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, color: statusColor, size: 30),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPriceStat("Old Price", "${priceItem.oldPrice ?? '-'}"),
              _buildPriceStat(
                "Change",
                "${priceItem.changePercentage ?? 0}%",
                color: statusColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceStat(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSourceChip(
    BuildContext context,
    ThemeData theme,
    PriceModel priceItem,
  ) {
    return Row(
      children: [
        if (dataIsNotEmpty(data: priceItem.sourceLogo)) ...[
          CircleAvatar(
            radius: 12,
            backgroundImage:
                CachedImage(imageUrl: priceItem.sourceLogo!).provider,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          priceItem.sourceName(context)!,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdateInfo(
    ThemeData theme,
    String lastUpdate,
    BuildContext context,
  ) {
    return Row(
      children: [
        Icon(Icons.history, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Text(
          "Last Update: ${formatDateTime(lastUpdate, context, format: dateFormat)}",
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
        ),
      ],
    );
  }
}
