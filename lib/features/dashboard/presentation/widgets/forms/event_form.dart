import 'dart:developer';
import 'dart:typed_data';
import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/mixins/image_picker.dart';
import 'package:calender/core/services/upload_image.dart';
import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:calender/features/dashboard/data/providers/categories.dart';
import 'package:calender/features/dashboard/data/providers/sections.dart';
import 'package:calender/features/dashboard/presentation/widgets/dashboard_dropdown.dart';
import 'package:calender/features/events/data/models/event_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EventForm extends ConsumerStatefulWidget {
  final EventModel? event;
  final Function(EventModel) onSave;

  const EventForm({super.key, this.event, required this.onSave});

  @override
  ConsumerState<EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<EventForm> with ImagePickerMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleEnController;
  late TextEditingController _descEnController;
  late TextEditingController _locationEnController;
  late TextEditingController _titleArController;
  late TextEditingController _descArController;
  late TextEditingController _locationArController;
  late String _date;
  late TextEditingController _imageController;
  late String _sectionId;
  late String _categoryId;
  Uint8List? uploadedImage;
  @override
  void initState() {
    super.initState();
    _titleEnController = TextEditingController(text: widget.event?.titleEn);
    _descEnController = TextEditingController(
      text: widget.event?.descriptionEn,
    );
    _locationEnController = TextEditingController(
      text: widget.event?.locationEn,
    );
    _titleArController = TextEditingController(text: widget.event?.titleAr);
    _descArController = TextEditingController(
      text: widget.event?.descriptionAr,
    );
    _locationArController = TextEditingController(
      text: widget.event?.locationAr,
    );
    _imageController = TextEditingController(text: widget.event?.image);
    _categoryId = widget.event?.categoryId ?? '';
    _sectionId = widget.event?.sectionId ?? '';
    _date = widget.event?.date ?? '';
  }

  void _uploadImage() async {
    final image = await pickImageFromGallery();
    if (image != null) {
      if (!mounted) return;
      final toStr = await image.readAsBytes();
      setState(() {
        uploadedImage = toStr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).value ?? [];
    final allSections = ref.watch(sectionsProvider).value ?? [];

    // 1. فلترة السكاشن بناءً على الكاتجوري المختار
    final filteredSections =
        allSections.where((section) {
          return section.categoryId == _categoryId;
        }).toList();

    final selectedCategory = categories.firstWhereOrNull(
      (e) => e.id == _categoryId,
    );

    // 2. التأكد إن السكشن المختار موجود فعلاً داخل القائمة المفلترة
    final selectedSection = filteredSections.firstWhereOrNull(
      (e) => e.id == _sectionId,
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
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                widget.event == null ? 'Add Event' : 'Edit Event',
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
                controller: _descEnController,
                labelText: 'Description En',
                maxLines: 2,
              ),
              MyTextField(
                controller: _descArController,
                labelText: 'Description Ar',
                maxLines: 2,
              ),
              GestureDetector(
                onTap: () async {
                  final date = await selectDate(context: context);
                  if (date != null) {
                    if (!context.mounted) return;
                    final time = await selectTime(context: context);
                    final dateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time?.hour ?? 0,
                      time?.minute ?? 0,
                    );
                    setState(() {
                      _date = dateTime.toIso8601String();
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    errorText:
                        dataIsNotEmpty(data: _date) ? null : 'Date is Required',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).greySwatch,
                      ),
                    ),
                  ),
                  child: Text(
                    !dataIsNotEmpty(data: _date)
                        ? 'Select Date'
                        : formatDateTime(_date, context),
                  ),
                ),
              ),
              MyTextField(
                controller: _locationEnController,
                labelText: 'Location En',
              ),
              MyTextField(
                controller: _locationArController,
                labelText: 'Location Ar',
              ),
              GestureDetector(
                onTap: _uploadImage,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).greySwatch,
                      ),
                    ),
                  ),
                  child:
                      uploadedImage == null
                          ? Text('Upload Image if you need!')
                          : Image.memory(uploadedImage!),
                ),
              ),
              MyTextField(controller: _imageController, labelText: 'Image URL'),
              // In real app, these should be Dropdowns selecting from available Categories/Sections
              DashboardDropdown(
                value: selectedCategory?.name(context),
                items:
                    categories
                        .map((e) => e.name(context))
                        .whereType<String>()
                        .toSet()
                        .toList(),
                onChanged: (String? name) {
                  // 5. Map the name back to the ID and update state
                  final cat = categories.firstWhereOrNull(
                    (e) => e.name(context) == name,
                  );
                  setState(() {
                    _categoryId = cat?.id ?? '';
                  });
                },
              ),
              const SizedBox(height: 8),
              DashboardDropdown(
                value: selectedSection?.title(context),
                items:
                    filteredSections
                        .map((e) => e.title(context))
                        .whereType<String>()
                        .toSet()
                        .toList(),
                onChanged: (String? name) {
                  // 5. Map the name back to the ID and update state
                  final sec = allSections.firstWhereOrNull(
                    (e) => e.title(context) == name,
                  );
                  setState(() {
                    _sectionId = sec?.id ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (!dataIsNotEmpty(data: _date)) {
                      return;
                    }
                    String? result;
                    if (uploadedImage != null) {
                      result = await ref
                          .read(imageUploadServiceProvider)
                          .uploadImage(image: uploadedImage!, context: context);

                      log('result $result');
                    }
                    final newEvent = EventModel(
                      id: widget.event?.id,
                      titleEn: _titleEnController.text,
                      titleAr: _titleArController.text,
                      descriptionEn: _descEnController.text,
                      descriptionAr: _descArController.text,
                      date: _date,
                      locationEn: _locationEnController.text,
                      locationAr: _locationArController.text,
                      image: result ?? _imageController.text,
                      categoryId: _categoryId,
                      sectionId: _sectionId,
                      createdAt: widget.event?.createdAt,
                    );
                    widget.onSave(newEvent);
                    if (!context.mounted) return;
                    context.pop();
                  }
                },
                text: 'Save',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
