import 'package:calender/features/dashboard/presentation/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/mixins/alert_mixin.dart';
import '../../news/data/models/news_category.dart';
import '../data/providers/news.dart';
import 'widgets/forms/news_category_form.dart';

class NewsCategoryView extends ConsumerWidget with AlertMixin {
  const NewsCategoryView({super.key});

  void _showForm(
    BuildContext context,
    WidgetRef ref, {
    NewsCategoryModel? category,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SizedBox(
              width: 400,
              child: NewsCategoryForm(
                category: category,
                onSave: (newCategory) {
                  if (category == null) {
                    ref
                        .read(newsProvider.notifier)
                        .addNewsCategory(newCategory);
                  } else {
                    ref
                        .read(newsProvider.notifier)
                        .updateNewsCategory(newCategory);
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
        ref.read(newsProvider.notifier).deleteNewsCategory(id);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(newsProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          final categoriesData = categories.categories?.data ?? [];
          if (categoriesData.isEmpty) {
            return const Center(child: Text('No categories added yet.'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 180 / 70,
            ),
            itemCount: categoriesData.length,
            itemBuilder: (context, index) {
              final category = categoriesData[index];
              return DashboardCard(
                id: 'ID : ${category.id}',
                title: category.name(context) ?? '',
                createdAt: category.createdAt ?? '',
                updatedAt: category.updatedAt ?? '',
                color: Color(category.color ?? 0xFF2196F3),
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
