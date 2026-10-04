import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/widgets/cached_image.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:calender/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../data/providers/events.dart';

/// Header image with back button and gradient overlay
class EventHeaderSliver extends StatelessWidget {
  final String? imageUrl;
  final String heroTag;

  const EventHeaderSliver({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: dataIsNotEmpty(data: imageUrl) ? 300 : null,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: theme.textTheme.bodyLarge?.color,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: heroTag,
              child:
                  dataIsNotEmpty(data: imageUrl)
                      ? CachedImage(imageUrl: imageUrl!)
                      : Container(
                        color: theme.scaffoldBackgroundColor.withValues(
                          alpha: 0.1,
                        ),
                        child: Icon(
                          Icons.event,
                          size: 80,
                          color: theme.scaffoldBackgroundColor.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
            ),
            // Gradient overlay for better text visibility (if title overlaps)
            // or just subtle darkening
            if (dataIsNotEmpty(data: imageUrl))
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent,
                      Colors.transparent,
                      theme.scaffoldBackgroundColor.withValues(alpha: 0.1),
                      theme.scaffoldBackgroundColor,
                    ],
                    stops: const [0.0, 0.3, 0.7, 0.9, 1.0],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Title and Category Section
class EventTitleSection extends ConsumerWidget {
  final String? title;
  final String? categoryId;

  const EventTitleSection({super.key, required this.title, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (title == null && categoryId == null) return const SizedBox.shrink();
    final category =
        ref.read(eventsProvider).value?.categoriesMap[categoryId ?? 0];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dataIsNotEmpty(data: categoryId))
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category?.name(context) ?? '', // Ideally should map ID to Name
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (title != null && title!.isNotEmpty)
            Text(
              title!,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 28,
                height: 1.2,
              ),
            ),
        ],
      ),
    );
  }
}

/// Meta Info (Date, Time, Location)
class EventMetaInfo extends StatelessWidget {
  final String? date;
  final String? location;

  const EventMetaInfo({super.key, required this.date, required this.location});

  @override
  Widget build(BuildContext context) {
    if (!dataIsNotEmpty(data: date) && !dataIsNotEmpty(data: location)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            if (dataIsNotEmpty(data: date))
              _buildMetaRow(
                context,
                Icons.calendar_today_rounded,
                formatDateTime(date ?? '', context, format: dateFormat),
                AppColors.accentColor,
              ),
            if (dataIsNotEmpty(data: location))
              Divider(
                height: 24,
                thickness: 1,
                color: Colors.grey.withValues(alpha: 0.1),
              ),
            if (location != null && location!.isNotEmpty)
              _buildMetaRow(
                context,
                Icons.location_on_rounded,
                location!,
                AppColors.dangerRed,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(
    BuildContext context,
    IconData icon,
    String text,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// Description Section
class EventDescription extends StatelessWidget {
  final String? description;

  const EventDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    if (description == null || description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.about.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
