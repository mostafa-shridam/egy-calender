import 'package:calender/features/dashboard/presentation/widgets/dashboard_card.dart';
import 'package:calender/features/dashboard/presentation/widgets/forms/category_form.dart';
import 'package:calender/features/events/data/models/event_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/mixins/alert_mixin.dart';
import '../data/providers/categories.dart';

class CategoryView extends ConsumerWidget with AlertMixin {
  const CategoryView({super.key});

  void _showForm(
    BuildContext context,
    WidgetRef ref, {
    EventCategory? category,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SizedBox(
              width: 400,
              child: CategoryForm(
                category: category,
                onSave: (newCategory) {
                  if (category == null) {
                    ref
                        .read(categoriesProvider.notifier)
                        .addCategory(newCategory);
                  } else {
                    ref
                        .read(categoriesProvider.notifier)
                        .updateCategory(newCategory);
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
      title: 'Delete Category',
      message: 'Are you sure you want to delete this category?',
      onConfirm: () {
        ref.read(categoriesProvider.notifier).deleteCategory(id);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories added yet.'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 180 / 70,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return DashboardCard(
                id: 'ID : ${category.id}',
                title: category.name(context),
                createdAt: category.createdAt,
                updatedAt: category.updatedAt,
                color: Color(category.color),
                onEdit: () => _showForm(context, ref, category: category),
                onDelete:
                    () => _confirmDelete(context, ref, category.id ?? "0"),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
