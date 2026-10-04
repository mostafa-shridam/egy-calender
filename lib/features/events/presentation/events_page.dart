import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/core/widgets/general_loading_widget.dart';
import 'package:calender/features/events/presentation/widgets/event_grid_card.dart';
import 'package:calender/features/main_page/data/providers/main_provider.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/home_ui.dart';
import '../../../core/theme/app_colors.dart';
import '../data/providers/events.dart';
import 'widgets/categories.dart';
import 'widgets/empty_event_widget.dart';
import 'widgets/event_widget.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});
  static const String routeName = "/events_page";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventsProvider).value;
    final uiState = ref.watch(mainProviderProvider);
    final isLoading = ref.watch(eventsProvider.select((e) => e.isLoading));
    final events = state?.filteredEvents ?? [];
    final selectedCategory = state?.allCategories.firstWhereOrNull(
      (c) => c.id == state.selectedCategoryId,
    );

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final filteredEvents =
        events.where((event) {
          final eDate = DateTime.tryParse(event.date ?? '') ?? now;
          final isPast = DateTime(
            eDate.year,
            eDate.month,
            eDate.day,
          ).isBefore(today);

          return uiState.filterType == EventFilterType.ongoing
              ? !isPast
              : isPast;
        }).toList();

    return isLoading
        ? const GeneralLoadingWidget()
        : Padding(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              await ref.read(eventsProvider.notifier).refresh();
            },
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 32,
                      icon: Icon(
                        uiState.viewType == EventViewType.list
                            ? Icons.grid_view
                            : Icons.view_list,
                      ),
                      onPressed: () async {
                        ref
                            .read(mainProviderProvider.notifier)
                            .toggleViewType();
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).greySwatch,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _FilterTab(
                                title: LocaleKeys.ongoing.tr(),
                                isSelected:
                                    uiState.filterType ==
                                    EventFilterType.ongoing,
                                onTap:
                                    () => ref
                                        .read(mainProviderProvider.notifier)
                                        .setFilterType(EventFilterType.ongoing),
                              ),
                            ),
                            Expanded(
                              child: _FilterTab(
                                title: LocaleKeys.completed.tr(),
                                isSelected:
                                    uiState.filterType ==
                                    EventFilterType.completed,
                                onTap:
                                    () => ref
                                        .read(mainProviderProvider.notifier)
                                        .setFilterType(
                                          EventFilterType.completed,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                CategoriesList(selectedCategoryId: selectedCategory?.id ?? '0'),
                const SizedBox(height: 16),
                if (filteredEvents.isEmpty)
                  ListView(
                    shrinkWrap: true,
                    children: [
                      EmptyEventWidget(
                        color:
                            selectedCategory?.color ??
                            AppColors.primaryColor.toARGB32(),
                      ),
                    ],
                  )
                else
                  Expanded(
                    child:
                        uiState.viewType == EventViewType.list
                            ? ListView.builder(
                              itemCount: filteredEvents.length,
                              itemBuilder: (context, index) {
                                final e = filteredEvents[index];
                                final section = state?.sectionsMap[e.sectionId];
                                final category =
                                    state?.categoriesMap[e.categoryId];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: EventWidget(
                                    event: e,
                                    section: section,
                                    category: category,
                                    isSection: selectedCategory?.id == '0',
                                  ),
                                );
                              },
                            )
                            : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.85,
                                  ),
                              itemCount: filteredEvents.length,
                              itemBuilder: (context, index) {
                                final e = filteredEvents[index];
                                final category =
                                    state?.categoriesMap[e.categoryId];
                                return EventGridCard(
                                  event: e,
                                  color:
                                      category?.color ??
                                      AppColors.primaryColor.toARGB32(),
                                  categoryName: category?.name(context) ?? '',
                                );
                              },
                            ),
                  ),
              ],
            ),
          ),
        );
  }
}

class _FilterTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
