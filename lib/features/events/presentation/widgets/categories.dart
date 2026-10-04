import 'package:calender/core/extension/theme_extenison.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/events.dart';

class CategoriesList extends ConsumerWidget {
  const CategoriesList({super.key, required this.selectedCategoryId});
  final String selectedCategoryId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.read(eventsProvider.select((e) => e.value?.allCategories ?? []));

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = categories[index].id == selectedCategoryId;
          return GestureDetector(
            onTap: () {
              ref
                  .watch(eventsProvider.notifier)
                  .filterEvents(categories[index].id ?? '0');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color:
                    !isSelected
                        ? Colors.transparent
                        : Color(
                          categories[index].color,
                        ).withAlpha(80),

                border: Border.all(
                  width: 1.4,

                  color:
                      isSelected
                          ? Colors.transparent
                          : Color(categories[index].color),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  categories[index].name(context),
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color:
                        isSelected
                            ? Color(categories[index].color)
                            : context.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
