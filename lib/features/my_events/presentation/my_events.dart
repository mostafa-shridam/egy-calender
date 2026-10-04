import 'package:calender/core/widgets/general_loading_widget.dart';
import 'package:calender/features/my_events/data/providers/my_events.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/empty_my_event_widget.dart';
import 'widgets/my_categories.dart';
import 'widgets/my_event_widget.dart';

class MyEventsPage extends ConsumerWidget {
  const MyEventsPage({super.key});

  static const routeName = '/my_events';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(myEventsProvider.select((e) => e.isLoading));
    final events = ref.read(
      myEventsProvider.select((e) => e.value?.filteredEvents ?? []),
    );
    final selectedCategoryId = ref.watch(
      myEventsProvider.select((e) => e.value?.selectedCategoryId ?? '0'),
    );
    final selectedCategoryColor = ref.watch(
      myEventsProvider.select(
        (e) =>
            e.value?.allCategories
                .firstWhereOrNull((e) => e.id == selectedCategoryId)
                ?.color ??
            0,
      ),
    );
    return isLoading
        ? const GeneralLoadingWidget()
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator.adaptive(
            onRefresh:
                () async =>
                    await ref.read(myEventsProvider.notifier).reloadData(),
            child: ListView(
              children: [
                MyCategories(selectedCategoryId: selectedCategoryId),
                if (events.isEmpty)
                  EmptyMyEventWidget(color: selectedCategoryColor),
                if (events.isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder:
                        (context, index) =>
                            MyEventWidget(event: events[index]),
                    itemCount: events.length,
                  ),
                ],
              ],
            ),
          ),
        );
  }
}
