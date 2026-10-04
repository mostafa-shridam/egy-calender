
import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:calender/features/settings/data/models/terms.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsForm extends StatefulWidget {
  final TermsModel? model;
  final Function(TermsModel) onSave;

  const TermsForm({super.key, this.model, required this.onSave});

  @override
  State<TermsForm> createState() => _TermsFormState();
}

class _TermsFormState extends State<TermsForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _titleArController;
  late TextEditingController _subtitleArController;

  @override
  void initState() {
    super.initState();
    _titleArController = TextEditingController(text: widget.model?.titleAr);
    _subtitleArController = TextEditingController(text: widget.model?.subtitleAr);
    _titleController = TextEditingController(text: widget.model?.titleEn);
    _subtitleController = TextEditingController(text: widget.model?.subtitleEn);
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
                widget.model == null ? 'Add Terms' : 'Edit Terms',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _titleController,
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
              MyTextField(
                controller: _subtitleController,
                labelText: 'Subtitle En',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),

              MyTextField(
                controller: _subtitleArController,
                labelText: 'Subtitle Ar',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              CustomButton(
                text: widget.model == null ? 'Add' : 'Update',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newCategory = TermsModel(
                      id: widget.model?.id,
                      titleEn: _titleController.text,
                      subtitleEn: _subtitleController.text,
                      titleAr: _titleArController.text,
                      subtitleAr: _subtitleArController.text,
                      date: DateTime.now().toIso8601String(),
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
