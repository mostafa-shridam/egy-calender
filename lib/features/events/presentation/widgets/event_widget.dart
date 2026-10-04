import 'package:calender/features/events/presentation/event_details_page.dart';
import 'package:calender/features/events/presentation/widgets/event_remaining_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/extension/theme_extenison.dart';
import '../../../../core/helper/help_functions.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../data/models/event_category.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_section.dart';

class EventWidget extends ConsumerWidget {
  const EventWidget({
    super.key,
    this.event,
    this.section,
    this.isSection = false,
    this.category,
  });
  final EventModel? event;
  final EventCategory? category;
  final EventSection? section;
  final bool isSection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap:
          () => context.pushNamed(
            EventDetailsPage.routeName,
            pathParameters: {'id': event?.id ?? ''},
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section != null && isSection) ...[
            Text(
              section?.title(context) ?? '',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
          ],
          Stack(
            children: [
              Positioned(
                top: 22,
                child: Container(
                  height: 60,
                  width: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        category?.color != null
                            ? Color(category?.color ?? 0xff)
                            : Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      category?.color != null
                          ? Color(category?.color ?? 0xff).withAlpha(80)
                          : Theme.of(context).greySwatch.shade200,
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
                            spacing: 6,
                            children: [
                              Text(
                                event?.title(context) ?? '',
                                style: context.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (dataIsNotEmpty(
                                data: event?.description(context),
                              ))
                                Text(
                                  event?.description(context) ?? '',
                                  style: context.textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (dataIsNotEmpty(data: event?.date))
                                Text(
                                  formatDateTime(
                                    event?.date ?? '',
                                    context,
                                    format: dateOnlyFormat,
                                  ),
                                  style: context.textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ),
                      EventRemainingDate(
                        date: event?.date ?? '',
                        createdAt: event?.createdAt ?? '',
                        color: category?.color ?? 0xff,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
