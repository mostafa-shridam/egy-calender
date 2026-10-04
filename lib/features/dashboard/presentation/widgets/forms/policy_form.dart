
import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:calender/features/settings/data/models/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PolicyForm extends StatefulWidget {
  final PrivacyPolicyModel? policyModel;
  final Function(PrivacyPolicyModel) onSave;

  const PolicyForm({super.key, this.policyModel, required this.onSave});

  @override
  State<PolicyForm> createState() => _PolicyFormState();
}

class _PolicyFormState extends State<PolicyForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleEnController;
  late TextEditingController _subtitleEnController;
  late TextEditingController _titleArController;
  late TextEditingController _subtitleArController;

  @override
  void initState() {
    super.initState();
    _titleArController = TextEditingController(
      text: widget.policyModel?.titleAr,
    );
    _subtitleArController = TextEditingController(
      text: widget.policyModel?.subTitleAr,
    );
    _titleEnController = TextEditingController(
      text: widget.policyModel?.titleEn,
    );
    _subtitleEnController = TextEditingController(
      text: widget.policyModel?.subTitleEn,
    );
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
                widget.policyModel == null ? 'Add Policy' : 'Edit Policy',
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
              MyTextField(
                controller: _subtitleEnController,
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
                text: widget.policyModel == null ? 'Add' : 'Update',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newCategory = PrivacyPolicyModel(
                      id: widget.policyModel?.id,
                      titleAr: _titleArController.text,
                      subTitleAr: _subtitleArController.text,
                      titleEn: _titleEnController.text,
                      subTitleEn: _subtitleEnController.text,
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

// String? id;
// String? name;
// int? color;
// String? createdAt;
// String? updatedAt;
// List<EventModel> events;
