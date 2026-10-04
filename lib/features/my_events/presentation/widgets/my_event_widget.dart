import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/features/my_events/data/models/my_event.dart';
import 'package:calender/features/my_events/presentation/add_edit_event.dart';
import 'package:calender/features/my_events/presentation/my_event_details_page.dart';
import 'package:calender/features/my_events/presentation/widgets/remaining_time_circular.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extension/theme_extenison.dart';
import '../../../../core/helper/help_functions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../data/providers/my_events.dart';
import 'slid_action.dart';

class MyEventWidget extends ConsumerWidget with AlertMixin {
  const MyEventWidget({super.key, this.event});
  final MyEvent? event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color =
        ref
            .watch(myEventsProvider.select((e) => e.value?.allCategories))
            ?.firstWhereOrNull((e) => e.id == event?.categoryId)
            ?.color ??
        Theme.of(context).primaryColor.toARGB32();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          if (event != null) {
            context.pushNamed(
              MyEventDetailsPage.routeName,
              pathParameters: {'id': event?.id ?? ''},
            );
          }
        },
        child: Slidable(
          key: ValueKey(event?.id),
          closeOnScroll: true,
          endActionPane: ActionPane(
            extentRatio: 0.4,
            motion: const BehindMotion(),
            children: [
              SlidAction(
                onTap:
                    () => showDangerAlert(
                      context: context,
                      title: LocaleKeys.deleteEvent.tr(),
                      message: LocaleKeys.deleteEventMessage.tr(),
                      onConfirm: () async {
                        await ref
                            .read(myEventsProvider.notifier)
                            .deleteEvent(event?.id ?? '');
                      },
                    ),
                color: AppColors.dangerRed,
                icon: Icons.delete_outline,
                title: LocaleKeys.delete.tr(),
              ),
              SlidAction(
                onTap:
                    () => context.pushNamed(
                      AddEditEventPage.routeName,
                      extra: event,
                    ),
                radius: 12,
                color: AppColors.successGreen,
                icon: Icons.edit_calendar_outlined,
                title: LocaleKeys.edit.tr(),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 16,
                child: Container(
                  height: 60,
                  width: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(color),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(color).withAlpha(80),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      if (dataIsNotEmpty(data: event?.image))
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage:
                              CachedImage(
                                imageUrl: event?.image ?? '',
                              ).provider,
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 12.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                event?.title ?? '',
                                style: context.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (dataIsNotEmpty(data: event?.description))
                                Text(
                                  event?.description ?? '',
                                  style: context.textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (dataIsNotEmpty(data: event?.startAt) ||
                                  dataIsNotEmpty(data: event?.endAt))
                                Text(
                                  '${formatDateTime(event?.startAt ?? '', context)} - ${formatDateTime(event?.endAt ?? '', context)}',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ),
                      RemainingTimeCircular(
                        startAt: event?.updatedAt ?? '',
                        endAt: event?.startAt ?? '',
                        color: color,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
