import 'dart:developer';

import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/features/my_events/presentation/add_edit_event.dart';
import 'package:calender/features/my_events/presentation/widgets/details/date_range_widget.dart';
import 'package:calender/features/my_events/presentation/widgets/details/priority_badge.dart';
import 'package:calender/features/my_events/presentation/widgets/details/section_container.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helper/icon_helper.dart';
import '../../../core/widgets/sliver_bar.dart';
import '../data/models/my_event.dart';
import '../data/providers/my_events.dart';
class MyEventDetailsPage extends ConsumerWidget with AlertMixin {
  const MyEventDetailsPage({super.key, required this.eventId});

  static const routeName = '/my-event-details';

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(myEventsProvider.select((e) => e.isLoading));
    log('📅 Building MyEventDetailsPage for eventId: $eventId, loadig $isLoading');

    final currentEvent =
        ref
            .watch(myEventsProvider)
            .value
            ?.events
            .firstWhereOrNull((e) => e.id == eventId) ??
        MyEvent();
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: [
                  // Custom Sliver App Bar with Hero Image
                  CustomSliverAppBar(imageUrl: currentEvent.image ?? ''),

                  // Event Details Section
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildEventDetails(context, ref, currentEvent),
                    ]),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(AddEditEventPage.routeName, extra: currentEvent);
        },
        icon: const Icon(Icons.edit),
        label: Text(LocaleKeys.edit.tr()),
      ),
    );
  }

  /// Handle delete with confirmation dialog
  Widget _buildEventDetails(
    BuildContext context,
    WidgetRef ref,
    MyEvent event,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Get category from unified provider for color
    final category = ref
        .watch(myEventsProvider.select((e) => e.value?.allCategories))
        ?.firstWhereOrNull((c) => c.id == event.categoryId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title (required, always show)
              _buildTitle(context, event.title ?? 'Untitled Event'),

              const SizedBox(height: 16),

              // Priority Badge
              Align(
                alignment: Alignment.centerLeft,
                child: PriorityBadge(
                  priority: event.priority,
                  animationDelay: const Duration(milliseconds: 100),
                ),
              ),

              const SizedBox(height: 24),

              // Date & Time Range
              DateRangeWidget(
                startAt: event.startAt,
                endAt: event.endAt,
                animationDelay: const Duration(milliseconds: 200),
              ),

              const SizedBox(height: 16),

              // Category Info (if exists)
              if (category != null)
                SectionContainer(
                  title: LocaleKeys.category.tr(),
                  animationDelay: const Duration(milliseconds: 300),
                  child: Row(
                    children: [
                      Icon(
                        IconHelper.getIcon(category.icon),
                        size: 18,
                        color: Color(
                          category.color ?? colorScheme.primary.toARGB32(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category.name ?? 'Unnamed Category',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // Description Section (if exists)
              if (event.description != null &&
                  event.description!.trim().isNotEmpty)
                SectionContainer(
                  title: LocaleKeys.description.tr(),
                  animationDelay: const Duration(milliseconds: 400),
                  child: Text(
                    event.description!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),

              // Sync Status Warning (if not synced)
              if (event.isSynced == false)
                SectionContainer(
                  animationDelay: const Duration(milliseconds: 500),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_off, size: 20, color: colorScheme.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This event is not synced to the cloud',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Bottom spacing for FAB
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  /// Build title section with fade-in animation
  Widget _buildTitle(BuildContext context, String title) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
