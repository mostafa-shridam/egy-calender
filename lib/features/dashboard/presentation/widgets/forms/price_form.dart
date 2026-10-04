import 'dart:typed_data';
import 'package:calender/core/mixins/image_picker.dart';
import 'package:calender/core/services/upload_image.dart';
import 'package:calender/core/widgets/custom_button.dart';
import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:calender/features/dashboard/presentation/widgets/dashboard_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../price/data/models/price_model.dart';

class PriceForm extends ConsumerStatefulWidget {
  final PriceModel? price;
  final Function(PriceModel) onSave;

  const PriceForm({super.key, this.price, required this.onSave});

  @override
  ConsumerState<PriceForm> createState() => _PriceFormState();
}

class _PriceFormState extends ConsumerState<PriceForm> with ImagePickerMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers (اللغتين)
  late TextEditingController _titleArController;
  late TextEditingController _descArController;
  late TextEditingController _sourceNameArController;
  late TextEditingController _titleEnController;
  late TextEditingController _descEnController;
  late TextEditingController _sourceNameEnController;
  // حقول الأرقام والبيانات
  late TextEditingController _currentPriceController;
  late TextEditingController _oldPriceController;
  late TextEditingController _changePercentController;
  late TextEditingController _imageUrlController;
  late TextEditingController _sourceLogoController;
  late String _changeStatus; // up, down, stable

  Uint8List? _mainImageBytes;
  Uint8List? _sourceLogoBytes;

  @override
  void initState() {
    super.initState();
    final p = widget.price;
    _titleArController = TextEditingController(text: p?.titleAr);
    _descArController = TextEditingController(text: p?.descriptionAr);
    _sourceNameArController = TextEditingController(text: p?.sourceNameAr);
    _titleEnController = TextEditingController(text: p?.titleEn);
    _descEnController = TextEditingController(text: p?.descriptionEn);
    _sourceNameEnController = TextEditingController(text: p?.sourceNameEn);

    _currentPriceController = TextEditingController(
      text: p?.currentPrice?.toString(),
    );
    _oldPriceController = TextEditingController(text: p?.oldPrice?.toString());
    _changePercentController = TextEditingController(
      text: p?.changePercentage?.toString(),
    );

    _imageUrlController = TextEditingController(text: p?.imageUrl);
    _sourceLogoController = TextEditingController(text: p?.sourceLogo);
    _changeStatus = p?.changeStatus ?? 'stable';
  }

  Future<void> _pickImage(bool isLogo) async {
    final image = await pickImageFromGallery();
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        if (isLogo) {
          _sourceLogoBytes = bytes;
        } else {
          _mainImageBytes = bytes;
        }
      });
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
            spacing: 12,
            children: [
              Text(
                widget.price == null ? 'Add Price Item' : 'Edit Price Item',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Divider(),

              // --- Arabic ---
              const _SectionHeader(title: "Arabic Details"),
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
                controller: _sourceNameArController,
                labelText: 'Source Name Ar',
              ),

              const Divider(),

              // --- English ---
              const _SectionHeader(title: "English Details"),
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
                controller: _sourceNameEnController,
                labelText: 'Source Name En',
              ),

              const Divider(),

              // --- Prices & Numbers ---
              const _SectionHeader(title: "Price & Trend"),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: _currentPriceController,
                      labelText: 'Current Price',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: MyTextField(
                      controller: _oldPriceController,
                      labelText: 'Old Price',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: _changePercentController,
                      labelText: 'Change %',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: DashboardDropdown(
                      value: _changeStatus,
                      items: const ['up', 'down', 'stable'],
                      onChanged:
                          (v) => setState(() => _changeStatus = v ?? 'stable'),
                    ),
                  ),
                ],
              ),
              // Images
              const Text("Main Image"),
              MyTextField(
                controller: _sourceLogoController,
                labelText: 'Source Logo URL',
              ),
              MyTextField(
                controller: _imageUrlController,
                labelText: 'Image URL',
              ),
              _ImagePickerBox(
                bytes: _mainImageBytes,
                onTap: () => _pickImage(false),
                icon: Icons.add_a_photo,
              ),

              const Text("Source Logo"),
              _ImagePickerBox(
                bytes: _sourceLogoBytes,
                onTap: () => _pickImage(true),
                icon: Icons.business,
                isCircle: true,
              ),

              const SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? finalImg = _imageUrlController.text;
                    String? finalLogo = _sourceLogoController.text;

                    if (_mainImageBytes != null) {
                      finalImg = await ref
                          .read(imageUploadServiceProvider)
                          .uploadImage(
                            image: _mainImageBytes!,
                            context: context,
                          );
                    }
                    if (_sourceLogoBytes != null) {
                      if (!context.mounted) return;
                      finalLogo = await ref
                          .read(imageUploadServiceProvider)
                          .uploadImage(
                            image: _sourceLogoBytes!,
                            context: context,
                          );
                    }

                    final newPrice = PriceModel(
                      id: widget.price?.id,
                      titleAr: _titleArController.text,
                      descriptionAr: _descArController.text,
                      sourceNameAr: _sourceNameArController.text,
                      titleEn: _titleEnController.text,
                      descriptionEn: _descEnController.text,
                      sourceNameEn: _sourceNameEnController.text,
                      currentPrice: double.tryParse(
                        _currentPriceController.text,
                      ),
                      oldPrice: double.tryParse(_oldPriceController.text),
                      changePercentage: double.tryParse(
                        _changePercentController.text,
                      ),
                      changeStatus: _changeStatus,
                      imageUrl: finalImg,
                      sourceLogo: finalLogo,
                      lastUpdate: DateTime.now().toIso8601String(),
                    );

                    widget.onSave(newPrice);
                    if (context.mounted) context.pop();
                  }
                },
                text: 'Save Price Item',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ويدجيت مساعدة للهيدر
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    ),
  );
}

// ويدجيت مساعدة لاختيار الصور
class _ImagePickerBox extends StatelessWidget {
  final Uint8List? bytes;
  final VoidCallback onTap;
  final IconData icon;
  final bool isCircle;

  const _ImagePickerBox({
    this.bytes,
    required this.onTap,
    required this.icon,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isCircle ? 100 : 150,
        width: isCircle ? 100 : double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(12),
        ),
        child:
            bytes != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(isCircle ? 100 : 12),
                  child: Image.memory(bytes!, fit: BoxFit.cover),
                )
                : Icon(icon, color: Colors.grey),
      ),
    );
  }
}
