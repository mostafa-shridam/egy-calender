import 'package:calender/features/my_events/data/providers/my_events.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helper/icon_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/locale_keys.g.dart';
import '../../add_edit_category/presentation/add_edit_category.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});
  static const String routeName = '/categories';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(
      myEventsProvider.select((c) => c.value?.categories ?? []),
    );
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.category.tr())),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: Text(LocaleKeys.add_category.tr()),
            onPressed: () {
              context.pushNamed(AddEditCategoryPage.routeName);
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
              title: Text(e.name ?? LocaleKeys.unkownError.tr()),
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
            ),
          ),
        ],
      ),
    );
  }
}
