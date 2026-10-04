import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

mixin ImagePickerMixin {
  final ImagePicker _picker = ImagePicker();

  /// Pick a single image from gallery
  Future<XFile?> pickImageFromGallery({
    ImageSource? source,
    Function(String message)? onError,
  }) async {
    try {
      XFile? image = await _picker.pickImage(
        source: source ?? ImageSource.gallery,
      );
      if (image == null) {
        return null;
      }

      // Compress image
      XFile bytes = await _compressImage(image);

      // Check file size
      if (await bytes.length() > 1024 * 1024) {
        onError?.call('Image size exceeds 1MB. Please select a smaller image.');
        return null;
      }
      return bytes;
    } catch (e) {
      log('Image pick error: $e');
      onError?.call('Failed to pick image: $e');
      return null;
    }
  }

  /// Pick multiple images from gallery
  Future<List<XFile>?> pickImagesFromGallery({
    Function(String message)? onError,
  }) async {
    try {
      List<XFile>? images = await _picker.pickMultiImage();
      if (images.isEmpty) return null;

      List<XFile> results = [];

      for (var x in images) {
        // Compress image
        XFile bytes = await _compressImage(x);

        if (await bytes.length() > 1024 * 1024) {
          onError?.call(
            'Image size exceeds 1MB. Please select a smaller image.',
          );
          continue;
        }

        results.add(bytes);
      }

      return results.isEmpty ? null : results;
    } catch (e) {
      debugPrint('Multiple image pick error: $e');
      return null;
    }
  }

  Future<XFile> _compressImage(XFile file) async {
    try {
      // 1. قراءة الملف كـ Bytes (تشتغل موبايل وويب)
      final Uint8List bytes = await file.readAsBytes();

      if (kIsWeb) {
        // 2. في الويب: نضغط ونرجع XFile.fromData مباشرة بدون التعامل مع المسارات
        final result = await FlutterImageCompress.compressWithList(
          bytes,
          minHeight: 1080,
          minWidth: 1080,
          quality: 70,
          format: CompressFormat.jpeg,
        );
        return XFile.fromData(result, mimeType: 'image/jpeg', name: file.name);
      } else {
        // 3. في الموبايل: نستخدم getTemporaryDirectory عادي
        final tempDir = await getTemporaryDirectory();
        final targetPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        final result = await FlutterImageCompress.compressAndGetFile(
          file.path,
          targetPath,
          minHeight: 1080,
          minWidth: 1080,
          quality: 70,
        );
        return result ?? file;
      }
    } catch (e) {
      log('Compression error: $e');
      return file; // لو حصل أي خطأ رجع الملف الأصلي
    }
  }
}
