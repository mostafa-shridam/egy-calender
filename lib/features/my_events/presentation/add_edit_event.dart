import 'dart:io';
import 'package:calender/core/enums/constants_enums.dart';
import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/helper/icon_helper.dart';
import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/core/mixins/image_picker.dart';
import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:calender/features/login/data/providers/save_user.dart';
import 'package:calender/features/login/presentation/login.dart';
import 'package:calender/features/my_events/data/models/my_category.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/upload_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/cached_image.dart';
import '../../add_edit_category/presentation/add_edit_category.dart';
import '../../auth/presentation/widgets/login_encouragement_dialog.dart';
import '../data/models/my_event.dart';
import '../data/providers/my_events.dart';
import 'widgets/build_date_time_row.dart';

class AddEditEventPage extends ConsumerStatefulWidget {
  const AddEditEventPage({super.key, this.event});
  final MyEvent? event;
  static const routeName = '/add_event';

  @override
  ConsumerState<AddEditEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEditEventPage>
    with ImagePickerMixin, AlertMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  Uint8List? _imageFile;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.event?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Initialize form state from provider
  void _initializeForm() {
    if (_isInitialized) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.event != null) {
        // Edit mode - initialize from existing event
        ref
            .read(myEventsProvider.notifier)
            .initializeFormForEdit(widget.event!);
      } else {
        // Add mode - reset form
        ref.read(myEventsProvider.notifier).resetForm();
      }
      _isInitialized = true;
    });
  }

  Future<void> _pickImage() async {
    final file = await pickImageFromGallery(
      onError: (msg) => showSnackBar(message: msg),
    );
    if (file != null) {
      setState(() {
        _imageFile = File(file.path).readAsBytesSync();
      });
    }
  }

  Future<void> _saveEvent(AsyncValue<MyEventsState> asyncState) async {
    if (!_formKey.currentState!.validate()) return;

    final state = asyncState.value;
    if (state == null) return;

    // Validate form state
    final validationError = state.validationError;
    if (validationError != null) {
      showSnackBar(message: validationError);
      return;
    }

    // Upload image if selected
    String? imageUrl = state.imageUrl;
    if (_imageFile != null) {
      imageUrl = await ref
          .read(imageUploadServiceProvider)
          .uploadImage(
            image: _imageFile!,
            context: context,
            bucket: Constants.myEvents.name,
            oldImageUrl: state.imageUrl,
          );
      if (imageUrl == null) return; // Upload failed
    }

    // Create event object
    final eventToSave = MyEvent(
      id: widget.event?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: state.priority,
      startAt: state.startAt,
      endAt: state.endAt,
      image: imageUrl,
      categoryId: state.selectedCategoryId ?? '0',
      createdAt: widget.event?.createdAt ?? DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    // Save event
    if (widget.event != null) {
      await ref.read(myEventsProvider.notifier).updateEvent(eventToSave);
      if (!mounted) return;
      context.pop(eventToSave);
    } else {
      await ref.read(myEventsProvider.notifier).addEvent(eventToSave);
      if (!mounted) return;
      context.pop(eventToSave);
    }

    // Check for errors
    final newState = ref.read(myEventsProvider);
    if (newState.hasError) {
      if (!mounted) return;
      showSnackBar(
        message: '${LocaleKeys.failed_to_save_event.tr()} ${newState.error}',
      );
      return;
    }

    // Success
    if (!mounted) return;
    showSnackBar(
      message:
          widget.event == null
              ? LocaleKeys.event_added_successfully.tr()
              : LocaleKeys.event_updated_successfully.tr(),
      type: SnackBarType.success,
    );
    LoginEncouragementDialog.show(context);
  }

  Future<void> _deleteEvent() async {
    if (widget.event == null) return;

    await ref.read(myEventsProvider.notifier).deleteEvent(widget.event!.id!);

    final state = ref.read(myEventsProvider);
    if (state.hasError) {
      if (!mounted) return;
      showSnackBar(
        message: LocaleKeys.failed_to_delete_event.tr(),
        type: SnackBarType.error,
      );
      return;
    }

    if (!mounted) return;
    showSnackBar(
      message: LocaleKeys.event_deleted_successfully.tr(),
      type: SnackBarType.success,
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(myEventsProvider);
    final isImageUploading = ref.watch(imageUploadLoadingProvider);

    // Initialize form state
    _initializeForm();
    return asyncState.when(
      loading:
          () => Scaffold(
            appBar: AppBar(
              title: Text(
                widget.event != null
                    ? LocaleKeys.update_event.tr()
                    : LocaleKeys.addEvent.tr(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stack) => Scaffold(
            appBar: AppBar(
              title: Text(
                widget.event != null
                    ? LocaleKeys.update_event.tr()
                    : LocaleKeys.addEvent.tr(),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => ref.read(myEventsProvider.notifier).reloadData(),
                    child: Text(LocaleKeys.retryButton.tr()),
                  ),
                ],
              ),
            ),
          ),
      data:
          (state) => AppLoader(
            isLoading: isImageUploading,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.event != null
                      ? LocaleKeys.update_event.tr()
                      : LocaleKeys.addEvent.tr(),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 20,
                    children: [
                      _buildImageSection(state),
                      MyTextField(
                        controller: _titleController,
                        labelText: LocaleKeys.eventTitle.tr(),
                        prefixIcon: Icons.title,
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? LocaleKeys.title_is_required.tr()
                                    : null,
                        maxLines: 3,
                        minLines: 1,
                      ),
                      MyTextField(
                        controller: _descriptionController,
                        labelText: LocaleKeys.details.tr(),
                        prefixIcon: Icons.description,
                        maxLines: 3,
                        minLines: 1,
                      ),
                      _buildCategorySelector(state),
                      _buildPrioritySelector(state),
                      BuildDateTimeRow(
                        label: LocaleKeys.start.tr(),
                        dateValue: state.startAt ?? '',
                        onDateTap:
                            () => ref
                                .read(myEventsProvider.notifier)
                                .setStartAt(context),
                      ),
                      BuildDateTimeRow(
                        label: LocaleKeys.end.tr(),
                        dateValue: state.endAt ?? '',
                        onDateTap:
                            () => ref
                                .read(myEventsProvider.notifier)
                                .setEndAt(context),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text:
                            widget.event != null
                                ? LocaleKeys.update_event.tr()
                                : LocaleKeys.save_event.tr(),
                        isLoading: isImageUploading,
                        onPressed: () => _saveEvent(asyncState),
                      ),
                      if (widget.event != null)
                        TextButton.icon(
                          onPressed:
                              () => showDangerAlert(
                                context: context,
                                title: LocaleKeys.delete_event.tr(),
                                message:
                                    LocaleKeys.are_you_sure_delete_event.tr(),
                                onConfirm: _deleteEvent,
                              ),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: Text(
                            LocaleKeys.deleteEvent.tr(),
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildImageSection(MyEventsState state) {
    final currentUser = SaveUser.instance.getUser();
    return Center(
      child: GestureDetector(
        onTap:
            currentUser == null
                ? () {
                  showWarningAlert(
                    context: context,
                    title: LocaleKeys.youNeedToLoginFirst.tr(),
                    message: LocaleKeys.loginNow.tr(),
                    onConfirm: () => context.pushNamed(LoginPage.routeName),
                    confirmText: LocaleKeys.login.tr(),
                  );
                }
                : _pickImage,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).greySwatch.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    _imageFile != null
                        ? Image.memory(_imageFile!, fit: BoxFit.cover)
                        : (dataIsNotEmpty(
                              data: state.imageUrl ?? widget.event?.image,
                            )
                            ? CachedImage(
                              imageUrl: state.imageUrl ?? widget.event!.image!,
                            )
                            : const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 50,
                              color: Colors.grey,
                            )),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector(MyEventsState state) {
    final selectedCategoryId = state.selectedCategoryId ?? '0';
    final selectedCategory =
        selectedCategoryId != '0'
            ? state.categoriesMap[selectedCategoryId]
            : MyCategory(
              id: '0',
              name: LocaleKeys.all.tr(),
              icon: IconHelper.getIconName(Icons.event),
              color: AppColors.primaryColor.toARGB32(),
            );

    return InkWell(
      onTap: () => _showCategoryPicker(state),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: LocaleKeys.category.tr(),
          prefixIcon: Icon(
            IconHelper.getIcon(selectedCategory?.icon),
            color: Color(
              selectedCategory?.color ?? AppColors.dangerRed.toARGB32(),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          children: [
            Text(
              selectedCategory?.name ?? LocaleKeys.all.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(MyEventsState state) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            children: [
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(LocaleKeys.add_category.tr()),
                onPressed: () {
                  context.pushNamed(AddEditCategoryPage.routeName);
                  if (context.canPop()) {
                    context.pop();
                  }
                },
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.allCategories.length,
                  itemBuilder: (context, index) {
                    final category = state.allCategories[index];
                    return ListTile(
                      leading: Icon(
                        IconHelper.getIcon(category.icon),
                        color: Color(
                          category.color ?? AppColors.primaryColor.toARGB32(),
                        ),
                      ),
                      title: Text(category.name ?? ''),
                      onTap: () {
                        ref
                            .read(myEventsProvider.notifier)
                            .selectCategory(category.id ?? '0');
                        context.pop();
                      },
                      trailing:
                          category.id == '0'
                              ? null
                              : IconButton(
                                onPressed:
                                    () => context.pushNamed(
                                      AddEditCategoryPage.routeName,
                                      extra: category,
                                    ),
                                icon: Icon(Icons.mode_edit_outline),
                              ),
                    );
                  },
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildPrioritySelector(MyEventsState state) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: ref
            .read(myEventsProvider.notifier)
            .getPriortyString(state.priority),
        prefixIcon: const Icon(Icons.flag),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: [
        DropdownMenuItem(value: 0, child: Text(LocaleKeys.priority_low.tr())),
        DropdownMenuItem(
          value: 1,
          child: Text(LocaleKeys.priority_medium.tr()),
        ),
        DropdownMenuItem(value: 2, child: Text(LocaleKeys.priority_high.tr())),
      ],
      initialValue: state.priority,
      onChanged: (val) {
        if (val != null) {
          ref.read(myEventsProvider.notifier).setPriority(val);
        }
      },
    );
  }
}
