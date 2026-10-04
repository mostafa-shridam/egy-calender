import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/core/widgets/cached_image.dart';
import 'package:calender/features/events/data/models/event_model.dart';
import 'package:calender/features/events/presentation/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/mixins/show_options_menu.dart';

class EventGridCard extends StatelessWidget with ShowOptionsMenu, AlertMixin {
  const EventGridCard({
    super.key,
    required this.event,
    required this.color,
    required this.categoryName,
  });

  final EventModel event;
  final int color;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final categoryColor = Color(color);
    return GestureDetector(
      onTap:
          () => context.pushNamed(
            EventDetailsPage.routeName,
            pathParameters: {'id': event.id ?? ''},
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Event Image or Placeholder
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child:
                    dataIsNotEmpty(data: event.image)
                        ? CachedImage(imageUrl: event.image ?? '')
                        : Container(
                          color: categoryColor.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.event,
                            color: categoryColor,
                            size: 40,
                          ),
                        ),
              ),
            ),
            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.title(context),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: categoryColor, size: 10),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            categoryName,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
