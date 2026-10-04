import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../helper/help_functions.dart';
import 'supabase.dart';

class ImageUploadService {
  final Ref ref;
  ImageUploadService(this.ref);

  Future<String?> uploadImage({
    required Uint8List image,
    required BuildContext context,
    String? bucket,
    String? oldImageUrl,
  }) async {
    if ( image.isEmpty) {
      return null;
    }

    ref.read(imageUploadLoadingProvider.notifier).state = true;

    try {
      // Delete old image
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await SupabaseService.instance.deleteImage(oldImageUrl, bucket: bucket);
      }

      final imageUrl = await SupabaseService.instance.uploadImage(
        file: image,
        bucket: bucket,
      );
      return imageUrl;
    } catch (e) {
      if (!context.mounted) return null;

      showSnackBar(message: 'Error uploading image: $e');
      return null;
    } finally {
      ref.read(imageUploadLoadingProvider.notifier).state = false;
    }
  }
}

// Riverpod provider
final imageUploadServiceProvider = Provider<ImageUploadService>(
  (ref) => ImageUploadService(ref),
);
final imageUploadLoadingProvider = StateProvider<bool>((ref) => false);
