import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extension/theme_extenison.dart';
import '../../../../core/helper/icon_helper.dart';
import '../../data/providers/my_events.dart';

class MyCategories extends ConsumerWidget {
  const MyCategories({super.key, required this.selectedCategoryId});

  final String selectedCategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(
      myEventsProvider.select((c) => c.value?.allCategories ?? []),
    );
    return SizedBox(
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(categories.length, (index) {
            final isSelected = categories[index].id == selectedCategoryId;

            return GestureDetector(
              onTap: () {
                ref
                    .watch(myEventsProvider.notifier)
                    .filterByCategory(categories[index].id ?? '0');
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      !isSelected
                          ? Colors.transparent
                          : Color(
                            categories[index].color ?? 0xFF5A7510,
                          ).withAlpha(80),

                  border: Border.all(
                    width: 1.4,

                    color:
                        isSelected
                            ? Colors.transparent
                            : Color(categories[index].color ?? 0xFF5A7510),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    spacing: 6,
                    children: [
                      if (categories[index].icon != null)
                        Icon(
                          IconHelper.getIcon(categories[index].icon),
                          color: Color(categories[index].color ?? 0xFF5A7510),
                          size: 16,
                        ),

                      Text(
                        categories[index].name ?? '',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color:
                              isSelected
                                  ? Color(categories[index].color ?? 0xFF5A7510)
                                  : context.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
