import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/color_selection.dart';
import '../../../../events/data/models/event_category.dart';

class CategoryForm extends StatefulWidget {
  final EventCategory? category;
  final Function(EventCategory) onSave;

  const CategoryForm({super.key, this.category, required this.onSave});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameEnController;
  late TextEditingController _nameArController;
  int _selectedColor = 0xFF2196F3; // Default Blue

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(text: widget.category?.nameEn);
    _nameArController = TextEditingController(text: widget.category?.nameAr);

    if (widget.category?.color != null) {
      _selectedColor = widget.category!.color;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                widget.category == null ? 'Add Category' : 'Edit Category',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _nameEnController,
                labelText: 'Name En',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              MyTextField(
                controller: _nameArController,
                labelText: 'Name Ar',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),

              // Simple Color Picker (Just a few choices for now)
              ColorSelectionWidget(
                selectedColor: Color(_selectedColor),
                onColorSelected:
                    (color) => setState(() {
                      _selectedColor = color.toARGB32();
                    }),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: widget.category == null ? 'Add' : 'Update',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newCategory = EventCategory(
                      id: widget.category?.id, // Simple ID gen
                      nameEn: _nameEnController.text,
                      nameAr: _nameArController.text,
                      color: _selectedColor,
                      createdAt: widget.category?.createdAt,
                      updatedAt: DateTime.now().toIso8601String(),
                    );
                    widget.onSave(newCategory);
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// String? id;
// String? name;
// int? color;
// String? createdAt;
// String? updatedAt;
// List<EventModel> events;
