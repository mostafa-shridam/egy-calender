import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/features/dashboard/presentation/widgets/dashboard_card.dart';
import 'package:calender/features/dashboard/presentation/widgets/forms/section_form.dart';
import 'package:calender/features/events/data/models/event_section.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers/categories.dart';
import '../data/providers/sections.dart';

class SectionView extends ConsumerWidget with AlertMixin {
  const SectionView({super.key});

  void _showForm(BuildContext context, WidgetRef ref, {EventSection? section}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SizedBox(
              width: 400,
              child: SectionForm(
                section: section,
                onSave: (newSection) {
                  if (section == null) {
                    ref.read(sectionsProvider.notifier).addSection(newSection);
                  } else {
                    ref
                        .read(sectionsProvider.notifier)
                        .updateSection(newSection);
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
      title: 'Delete Section',
      message: 'Are you sure you want to delete this section?',
      onConfirm: () {
        ref.read(sectionsProvider.notifier).deleteSection(id);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(sectionsProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: sectionsAsync.when(
        data: (sections) {
          if (sections.isEmpty) {
            return const Center(child: Text('No sections added yet.'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 180 / 70,
            ),
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              final category = ref
                  .watch(categoriesProvider)
                  .value
                  ?.firstWhereOrNull((e) => e.id == section.categoryId);
              return DashboardCard(
                id: 'Category  : ${category?.name(context)} ',
                title: section.title(context),
                createdAt: section.createdAt,
                updatedAt: section.updatedAt,
                onEdit: () => _showForm(context, ref, section: section),
                onDelete: () => _confirmDelete(context, ref, section.id!),
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
