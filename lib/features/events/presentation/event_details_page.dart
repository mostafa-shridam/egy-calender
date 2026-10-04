import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:calender/features/events/data/models/event_model.dart';
import 'package:calender/features/events/presentation/widgets/event_details_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/sliver_bar.dart';
import '../data/providers/events.dart';

class EventDetailsPage extends ConsumerWidget {
  static const String routeName = '/event_details';

  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(eventsProvider.select((e) => e.isLoading));
    log(
      '🧭 Navigated to EventDetailsPage with eventId: $eventId. , isLoading $isLoading',
    );
    final event =
        ref.watch(
          eventsProvider.select(
            (state) => state.value?.events.firstWhereOrNull(
              (element) => element.id == eventId,
            ),
          ),
        ) ??
        EventModel();
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: [
                  CustomSliverAppBar(imageUrl: event.image ?? ''),
    
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _AnimatedSection(
                        delay: 100,
                        child: EventTitleSection(
                          title: event.title(context),
                          categoryId: event.categoryId,
                        ),
                      ),
                      _AnimatedSection(
                        delay: 200,
                        child: EventMetaInfo(
                          date: event.date,
                          location: event.location(context),
                        ),
                      ),
                      _AnimatedSection(
                        delay: 300,
                        child: EventDescription(
                          description: event.description(context),
                        ),
                      ),
                      // Add bottom padding
                      const SizedBox(height: 50),
                    ]),
                  ),
                ],
              ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedSection({required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }
}
