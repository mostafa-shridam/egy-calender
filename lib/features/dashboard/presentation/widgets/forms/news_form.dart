import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/mixins/image_picker.dart';
import 'package:calender/core/services/upload_image.dart';
import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:calender/features/dashboard/presentation/widgets/dashboard_dropdown.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../news/data/models/news_model.dart';
import '../../../data/providers/news.dart';

class NewsForm extends ConsumerStatefulWidget {
  final NewsModel? news;
  final Function(NewsModel) onSave;

  const NewsForm({super.key, this.news, required this.onSave});

  @override
  ConsumerState<NewsForm> createState() => _NewsFormState();
}

class _NewsFormState extends ConsumerState<NewsForm> with ImagePickerMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers للعربي
  late TextEditingController _titleArController;
  late TextEditingController _descArController;
  late TextEditingController _contentArController;
  late TextEditingController _sourceNameArController;

  // Controllers للإنجليزي
  late TextEditingController _titleEnController;
  late TextEditingController _descEnController;
  late TextEditingController _contentEnController;
  late TextEditingController _sourceNameEnController;

  // حقول أخرى
  late TextEditingController _authorController;
  late TextEditingController _newsUrlController;
  late TextEditingController _imageUrlController;
  late TextEditingController _sourceLogoController;

  late String _publishedAt;
  late String _categoryId;

  Uint8List? _newsImageBytes;
  Uint8List? _sourceLogoBytes;

  @override
  void initState() {
    super.initState();
    final news = widget.news;
    _titleArController = TextEditingController(text: news?.titleAr);
    _descArController = TextEditingController(text: news?.descriptionAr);
    _contentArController = TextEditingController(text: news?.contentAr);
    _sourceNameArController = TextEditingController(text: news?.sourceNameAr);

    _titleEnController = TextEditingController(text: news?.titleEn);
    _descEnController = TextEditingController(text: news?.descriptionEn);
    _contentEnController = TextEditingController(text: news?.contentEn);
    _sourceNameEnController = TextEditingController(text: news?.sourceNameEn);

    _authorController = TextEditingController(text: news?.author);
    _newsUrlController = TextEditingController(text: news?.newsUrl);
    _imageUrlController = TextEditingController(text: news?.imageUrl);
    _sourceLogoController = TextEditingController(text: news?.sourceLogo);

    _categoryId = news?.categoryId ?? '';
    _publishedAt = news?.publishedAt ?? DateTime.now().toIso8601String();
  }

  Future<void> _pickImage(bool isLogo) async {
    final image = await pickImageFromGallery();
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        if (isLogo) {
          _sourceLogoBytes = bytes;
        } else {
          _newsImageBytes = bytes;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(newsProvider).value?.categories?.data ?? [];
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
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                widget.news == null ? 'Add News' : 'Edit News',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const Divider(),
              const Text(
                "Arabic Content",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MyTextField(
                controller: _titleArController,
                labelText: 'Title Ar',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              MyTextField(
                controller: _descArController,
                labelText: 'Description Ar',
                maxLines: 2,
              ),
              MyTextField(
                controller: _contentArController,
                labelText: 'Full Content Ar',
                maxLines: 4,
              ),
              MyTextField(
                controller: _sourceNameArController,
                labelText: 'Source Name Ar',
              ),

              const Divider(),
              const Text(
                "English Content",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MyTextField(
                controller: _titleEnController,
                labelText: 'Title En',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              MyTextField(
                controller: _descEnController,
                labelText: 'Description En',
                maxLines: 2,
              ),
              MyTextField(
                controller: _contentEnController,
                labelText: 'Full Content En',
                maxLines: 4,
              ),
              MyTextField(
                controller: _sourceNameEnController,
                labelText: 'Source Name En',
              ),

              const Divider(),

              // Date Picker
              GestureDetector(
                onTap: () async {
                  final date = await selectDate(context: context);
                  if (date != null) {
                    setState(() => _publishedAt = date.toIso8601String());
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Published At',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(formatDateTime(_publishedAt, context)),
                ),
              ),

              MyTextField(
                controller: _authorController,
                labelText: 'Author Name',
              ),
              MyTextField(
                controller: _newsUrlController,
                labelText: 'News Original URL',
              ),

              // Category Dropdown
              DashboardDropdown(
                value: selectedCategory?.name(context),
                items:
                    categories
                        .map((e) => e.name(context))
                        .whereType<String>()
                        .toList(),
                onChanged: (name) {
                  final cat = categories.firstWhereOrNull(
                    (e) => e.name(context) == name,
                  );
                  setState(() => _categoryId = cat?.id ?? '');
                },
              ),

              // News Image Upload
              const Text("News Main Image"),
              GestureDetector(
                onTap: () => _pickImage(false),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      _newsImageBytes != null
                          ? Image.memory(_newsImageBytes!, fit: BoxFit.cover)
                          : const Icon(Icons.add_a_photo),
                ),
              ),

              // Source Logo Upload
              const Text("Source Logo"),
              GestureDetector(
                onTap: () => _pickImage(true),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  child:
                      _sourceLogoBytes != null
                          ? ClipOval(
                            child: Image.memory(
                              _sourceLogoBytes!,
                              fit: BoxFit.cover,
                            ),
                          )
                          : const Icon(Icons.business),
                ),
              ),

              const SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? finalImageUrl = _imageUrlController.text;
                    String? finalLogoUrl = _sourceLogoController.text;

                    // رفع الصور إذا تم اختيارها
                    if (_newsImageBytes != null) {
                      finalImageUrl = await ref
                          .read(imageUploadServiceProvider)
                          .uploadImage(
                            image: _newsImageBytes!,
                            context: context,
                          );
                    }
                    if (_sourceLogoBytes != null) {
                      if (!context.mounted) return;
                      finalLogoUrl = await ref
                          .read(imageUploadServiceProvider)
                          .uploadImage(
                            image: _sourceLogoBytes!,
                            context: context,
                          );
                    }

                    final newNews = NewsModel(
                      id: widget.news?.id,
                      titleAr: _titleArController.text,
                      descriptionAr: _descArController.text,
                      contentAr: _contentArController.text,
                      sourceNameAr: _sourceNameArController.text,
                      titleEn: _titleEnController.text,
                      descriptionEn: _descEnController.text,
                      contentEn: _contentEnController.text,
                      sourceNameEn: _sourceNameEnController.text,
                      author: _authorController.text,
                      newsUrl: _newsUrlController.text,
                      imageUrl: finalImageUrl,
                      sourceLogo: finalLogoUrl,
                      categoryId: _categoryId,
                      publishedAt: _publishedAt,
                    );

                    widget.onSave(newNews);
                    if (context.mounted) context.pop();
                  }
                },
                text: 'Save News',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
