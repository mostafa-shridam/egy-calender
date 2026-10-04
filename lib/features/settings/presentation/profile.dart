import 'dart:io';
import 'package:calender/core/enums/constants_enums.dart';
import 'package:calender/core/services/upload_image.dart';
import 'package:calender/core/widgets/app_loader.dart';
import 'package:calender/features/login/data/providers/auth.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/helper/help_functions.dart';
import '../../../core/mixins/image_picker.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/my_text_filed.dart';
import '../../login/data/models/user_model.dart';
import 'widgets/profile_image.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key, required this.user});
  static const routeName = '/profile';
  final UserModel user;
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with ImagePickerMixin {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _phoneController.addListener(_onFormChanged);
    _nameController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await pickImageFromGallery();
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  bool get _changesMade {
    return _nameController.text == widget.user.name &&
        _emailController.text == widget.user.email &&
        _phoneController.text == widget.user.phone &&
        _imageFile == null;
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final isLoading =
        ref.watch(imageUploadLoadingProvider) ||
        ref.watch(authProvider.select((e) => e.isLoading ?? false));
    return AppLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.edit_profile.tr())),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                // Profile Image Section
                ProfileImage(
                  avatar: user.avatar ?? '',
                  pickImage: _pickImage,
                  imageFile: _imageFile,
                ),
                const SizedBox(height: 16),

                // Form Fields
                MyTextField(
                  controller: _nameController,
                  labelText: LocaleKeys.name.tr(),
                  hintText: LocaleKeys.pleaseEnterName.tr(),
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.pleaseEnterName.tr();
                    }
                    return null;
                  },
                ),
                MyTextField(
                  controller: _emailController,
                  labelText: LocaleKeys.email.tr(),
                  hintText: LocaleKeys.emailHint.tr(),
                  prefixIcon: Icons.email_outlined,
                  enabled:
                      false, // Read only as per standard UX but can be changed
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.enter_valid_email.tr();
                    }
                    return null;
                  },
                ),
                MyTextField(
                  controller: _phoneController,
                  labelText: LocaleKeys.enter_valid_phone.tr(),
                  hintText: LocaleKeys.enter_valid_phone.tr(),
                  prefixIcon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_changesMade)
                  // Save Button
                  CustomButton(
                    text: LocaleKeys.saveChanges.tr(),
                    isLoading: isLoading,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      String? uploadedImage;
                      if (_imageFile != null) {
                        uploadedImage = await ref
                            .read(imageUploadServiceProvider)
                            .uploadImage(
                              image: _imageFile!.readAsBytesSync(),
                              oldImageUrl: user.avatar,
                              bucket: Constants.profileImages.name,
                              context: context,
                            );
                      }
                      final model = UserModel(
                        id: widget.user.id,
                        name: _nameController.text,
                        email: widget.user.email,
                        phone: _phoneController.text,
                        avatar: uploadedImage ?? user.avatar,
                        deviceId: user.deviceId,
                        createdAt: user.createdAt,
                        updatedAt: DateTime.now().toIso8601String(),
                        isVerified: user.isVerified,
                        isBlocked: user.isBlocked,
                      );
                      await ref.read(authProvider.notifier).updateUser(model);
                      if (!context.mounted) return;
                      showSnackBar(
                        message: LocaleKeys.updatedSuccessfully.tr(),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
