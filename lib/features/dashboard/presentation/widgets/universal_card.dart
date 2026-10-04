import 'package:calender/features/events/data/models/event_model.dart';
import 'package:calender/features/price/data/models/price_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helper/help_functions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../news/data/models/news_model.dart';

class UniversalCard extends ConsumerWidget {
  final NewsModel? news;
  final EventModel? event;
  final PriceModel? price;
  final int index;
  final bool isSelected;
  final bool showSelection;
  final bool isLoading;
  final VoidCallback? onSelect;
  final VoidCallback onDelete;
  final VoidCallback? onUpload;
  final VoidCallback onEdit;

  const UniversalCard({
    super.key,
    this.news,
    this.event,
    this.price,
    this.showSelection = true,
    required this.index,
    required this.isSelected,
    required this.isLoading,
    this.onSelect,
    required this.onDelete,
    required this.onUpload,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = news?.imageUrl ?? event?.image ?? price?.imageUrl ?? '';
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.successGreen : AppColors.accentColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActionButtons(),
            if (dataIsNotEmpty(data: image)) _buildImageWithDate(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showSelection)
          IconButton(
            onPressed: onSelect,
            icon: Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color:
                  isSelected ? AppColors.successGreen : AppColors.accentColor,
            ),
          ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(Icons.delete, color: AppColors.dangerRed),
        ),
      ],
    );
  }

  Widget _buildImageWithDate(BuildContext context) {
    final image = news?.imageUrl ?? event?.image ?? price?.imageUrl ?? '';
    final date = news?.publishedAt ?? event?.date ?? price?.lastUpdate ?? '';
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: CachedImage(imageUrl: image),
        ),
        if (dataIsNotEmpty(data: date))
          Positioned.directional(
            textDirection: TextDirection.ltr,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                formatDateTime(date, context, format: dateOnlyFormat),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final titleEn = news?.titleEn ?? event?.titleEn ?? price?.titleEn ?? '';
    final titleAr = news?.titleAr ?? event?.titleAr ?? price?.titleAr ?? '';
    final descEn =
        news?.descriptionEn ??
        event?.descriptionEn ??
        price?.descriptionEn ??
        '';
    final descAr =
        news?.descriptionAr ??
        event?.descriptionAr ??
        price?.descriptionAr ??
        '';
    final sourceEn =
        news?.sourceNameEn ?? event?.locationEn ?? price?.sourceNameEn ?? '';
    final sourceAr =
        news?.sourceNameAr ?? event?.locationAr ?? price?.sourceNameAr ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (price != null) _buildPriceBadge(),

          if (dataIsNotEmpty(data: titleAr))
            Text(
              titleAr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
          if (dataIsNotEmpty(data: titleEn))
            Text(
              titleEn,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          const Divider(height: 20),

          if (dataIsNotEmpty(data: descAr)) ...[
            const Text("الوصف:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(descAr, textDirection: TextDirection.rtl),
            const SizedBox(height: 10),
          ],

          if (dataIsNotEmpty(data: descEn)) ...[
            const Text(
              "Description:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(descEn),
            const SizedBox(height: 10),
          ],

          if (dataIsNotEmpty(data: news?.contentAr)) ...[
            const Text(
              "المحتوى:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              news!.contentAr!.length > 150
                  ? '${news!.contentAr!.substring(0, 150)}...'
                  : news!.contentAr!,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
          ],

          Row(
            children: [
              const Icon(Icons.source, color: Colors.blue, size: 20),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  [
                    if (dataIsNotEmpty(data: sourceAr)) sourceAr,
                    if (dataIsNotEmpty(data: sourceEn)) sourceEn,
                    if (dataIsNotEmpty(data: news?.author)) news?.author,
                  ].where((e) => e != null).join(' | '),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              if (onUpload != null)
                Expanded(
                  child: CustomButton(
                    text: 'Upload',
                    isLoading: isLoading,
                    onPressed: () {
                      if (isLoading) return;
                      onUpload!();
                    },
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Edit',
                  grideantColor: AppColors.warningYellow,
                  onPressed: () {
                    if (isLoading) return;
                    onEdit();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge() {
    final isUp = price?.changeStatus == 'up';
    final statusColor =
        isUp
            ? Colors.green
            : (price?.changeStatus == 'down' ? Colors.red : Colors.grey);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${price?.currentPrice} EGP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              if (price?.oldPrice != null)
                Text(
                  "${price?.oldPrice} EGP",
                  style: const TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          Row(
            children: [
              Icon(
                isUp ? Icons.trending_up : Icons.trending_down,
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                "${price?.changePercentage}%",
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
