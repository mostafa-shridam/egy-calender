import 'package:calender/core/helper/icon_helper.dart';
import 'package:calender/core/mixins/bottom_sheet_mixin.dart';
import 'package:calender/features/add_edit_category/presentation/add_edit_category.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/providers/my_events.dart';

class CategoryWidget extends ConsumerWidget with BottomSheetMixin {
  const CategoryWidget({super.key, this.categoryId});

  final String? categoryId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myEventsProvider);
    final selectedCategory = state.value?.categories.firstWhereOrNull(
      (element) => element.id == categoryId,
    );
    return ListTile(
      title: Row(
        children: [
          Icon(
            IconHelper.getIcon(selectedCategory?.icon),
            color: Color(
              selectedCategory?.color ?? AppColors.primaryColor.toARGB32(),
            ),
          ),
          const SizedBox(width: 8),
          Text(selectedCategory?.name ?? 'All'),
        ],
      ),

      onTap: () => _showCategoriesSheet(context, ref),
    );
  }

  void _showCategoriesSheet(BuildContext context, WidgetRef ref) {
    final categories = ref.read(myEventsProvider).value?.allCategories ?? [];

    showCustomBottomSheet(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
            onPressed: () {
              context.pushNamed(AddEditCategoryPage.routeName, extra: null);
              // context.pop();
              // _showAddCategorySheet(context, ref);
            },
          ),
          const Divider(),
          ...categories.map(
            (e) => ListTile(
              leading: Icon(
                IconHelper.getIcon(e.icon),
                size: 24,
                color: Color(e.color ?? AppColors.primaryColor.toARGB32()),
              ),
              title: Text(e.name ?? 'Unnamed'),
              trailing:
                  e.id == '0'
                      ? const SizedBox()
                      : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pushNamed(
                                AddEditCategoryPage.routeName,
                                extra: e,
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Color(
                                e.color ?? AppColors.primaryColor.toARGB32(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await ref
                                  .read(myEventsProvider.notifier)
                                  .deleteCategory(e.id ?? '');
                            },
                            icon: Icon(
                              Icons.delete,
                              color: AppColors.dangerRed,
                            ),
                          ),
                        ],
                      ),
              onTap: () {
                ref
                    .read(myEventsProvider.notifier)
                    .filterByCategory(e.id ?? '0');
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
