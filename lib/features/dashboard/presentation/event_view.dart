import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/features/dashboard/data/providers/events.dart';
import 'package:calender/features/dashboard/presentation/widgets/forms/event_form.dart';
import 'package:calender/features/dashboard/presentation/widgets/universal_card.dart';
import 'package:calender/features/events/data/models/event_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../events/data/models/event_category.dart';
import '../data/providers/categories.dart';
import '../data/providers/event_filter_provider.dart';
import '../data/providers/sections.dart';
import 'universal_ai_proccessor.dart';
import 'widgets/dashboard_filter_bar.dart';

class EventView extends ConsumerWidget with AlertMixin {
  const EventView({super.key});

  void _showForm(BuildContext context, WidgetRef ref, {EventModel? event}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SizedBox(
              width: 400,
              child: EventForm(
                event: event,
                onSave: (newEvent) {
                  if (event == null) {
                    ref.read(eventsProvider.notifier).addEvent(newEvent);
                  } else {
                    ref.read(eventsProvider.notifier).updateEvent(newEvent);
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
      title: 'Delete Event',
      message: 'Are you sure you want to delete this event?',
      onConfirm: () async {
        await ref.read(eventsProvider.notifier).deleteEvent(id);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredEvents = ref.watch(filteredEventsProvider);

    final eventsAsync = ref.watch(eventsProvider);
    final isInitialLoading = eventsAsync.isLoading && eventsAsync.value == null;

    if (isInitialLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (eventsAsync.hasError && eventsAsync.value == null) {
      return Scaffold(body: Center(child: Text('Error: ${eventsAsync.error}')));
    }

    // Group events by category
    final categories = ref.watch(categoriesProvider).value ?? [];
    final Map<EventCategory, List<EventModel>> groupedEvents = {};

    for (final event in filteredEvents) {
      final category = categories.firstWhereOrNull(
        (c) => c.id == event.categoryId,
      );
      if (category != null) {
        groupedEvents.putIfAbsent(category, () => []).add(event);
      }
    }

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _showForm(context, ref),
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed:
                () => context.pushNamed(
                  UniversalAIProcessor.routeName,
                  extra: {
                    'type': AIType.events,
                    'categories': ref.watch(categoriesProvider).value ?? [],
                    'sections': ref.watch(sectionsProvider).value ?? [],
                  },
                ),
            child: const Icon(Icons.auto_awesome),
          ),
        ],
      ),
      body: Column(
        children: [
          const DashboardFilterBar(),
          const SizedBox(height: 16),
          if (filteredEvents.isEmpty)
            const Expanded(child: Center(child: Text('No events found.')))
          else
            Expanded(
              child: CustomScrollView(
                slivers:
                    groupedEvents.entries.map((entry) {
                      final category = entry.key;
                      final events = entry.value;

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // Category Header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Text(
                                category.name(context),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            // Events Grid for this category
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StaggeredGrid.count(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  children: List.generate(events.length, (
                                    index,
                                  ) {
                                    final event = events[index];
                                    return UniversalCard(
                                      showSelection: false,

                                      index: index,
                                      event: event,
                                      isSelected: false,
                                      isLoading: false,
                                      onSelect: null,
                                      onDelete:
                                          () => _confirmDelete(
                                            context,
                                            ref,
                                            event.id ?? '',
                                          ),
                                      onUpload: null,
                                      onEdit:
                                          () => _showForm(
                                            context,
                                            ref,
                                            event: event,
                                          ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
