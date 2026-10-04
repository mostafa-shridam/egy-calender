import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:calender/features/dashboard/data/providers/categories.dart';
import 'package:calender/features/dashboard/presentation/widgets/dashboard_dropdown.dart';
import 'package:calender/features/events/data/models/event_section.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SectionForm extends ConsumerStatefulWidget {
  final EventSection? section;
  final Function(EventSection) onSave;

  const SectionForm({super.key, this.section, required this.onSave});

  @override
  ConsumerState<SectionForm> createState() => _SectionFormState();
}

class _SectionFormState extends ConsumerState<SectionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleEnController;
  late TextEditingController _titleArController;

  // 1. Store the selected ID in a local variable
  late String _categoryId;

  @override
  void initState() {
    super.initState();
    _titleEnController = TextEditingController(text: widget.section?.titleEn);
    _titleArController = TextEditingController(text: widget.section?.titleAr);
    // 2. Initialize the selected ID from the existing section
    _categoryId = widget.section?.categoryId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // 3. Watch the provider so the UI updates if categories load late
    final categories = ref.watch(categoriesProvider).value ?? [];

    // Find the current category object to get its name for the display value
    final selectedCategory = categories.firstWhereOrNull(
      (e) => e.id == _categoryId,
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.section == null ? 'Add Section' : 'Edit Section',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _titleEnController,
                labelText: 'Title En',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              MyTextField(
                controller: _titleArController,
                labelText: 'Title Ar',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              // 4. Integrated Dropdown
              DashboardDropdown(
                items:
                    categories
                        .map((e) => e.name(context))
                        .whereType<String>()
                        .toSet()
                        .toList(),

                value: selectedCategory?.name(context),
                onChanged: (String? name) {
                  final cat = categories.firstWhereOrNull(
                    (e) => e.name(context) == name,
                  );
                  setState(() {
                    _categoryId = cat?.id ?? '';
                  });
                },
              ),

              const SizedBox(height: 16),
              CustomButton(
                text: widget.section == null ? 'Add Section' : 'Edit Section',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newSection = EventSection(
                      id: widget.section?.id,
                      titleEn: _titleEnController.text,
                      titleAr: _titleArController.text,
                      createdAt: widget.section?.createdAt,
                      categoryId: _categoryId,
                    );
                    widget.onSave(newSection);
                    context.pop();
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
