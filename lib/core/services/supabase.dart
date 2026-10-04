import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/secrets.dart';
import '../enums/constants_enums.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  SupabaseService._internal();
  static SupabaseService get instance => _instance;
  static String get supabaseAPIKey => Secrets.supabaseAnonKey;
  static String get supabaseUrl => Secrets.supabaseUrl;
  final SupabaseClient _supabase = Supabase.instance.client;
  static Future<void> initSupabase() async {
    await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAPIKey);
  }

  Future<bool> _checkBucketExists(String name) async {
    try {
      final buckets = await _supabase.storage.listBuckets();
      final bucket = buckets.any((bucket) => bucket.name == name);
      return bucket;
    } catch (e) {
      log('Error checking bucket existence: $e', name: 'SupabaseService');
      return false;
    }
  }

  final String bucketName = Constants.images.name;

  Future<void> _createBucketIfNeeded({String? name}) async {
    if (!await _checkBucketExists(name ?? bucketName)) {
      await _supabase.storage.createBucket(name ?? bucketName);
    }
  }

  Future<String?> uploadImage({required Uint8List file, String? bucket}) async {
    try {
      await _createBucketIfNeeded(name: bucket ?? bucketName);

      final fileName =
          '${bucket ?? bucketName}/${DateTime.now().millisecondsSinceEpoch}';

      await _supabase.storage
          .from(bucket ?? bucketName)
          .uploadBinary(fileName, file);

      final publicUrl = _supabase.storage
          .from(bucket ?? bucketName)
          .getPublicUrl(fileName);

      log('[SupabaseService] ✅ Image uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      log('Error uploading image: $e');

      return null;
    }
  }

  String extractFilePath(String url, String bucketUrl) {
    return url.replaceFirst('$bucketUrl/', '');
  }

  Future<void> deleteImage(String imageUrl, {String? bucket}) async {
    try {
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments;
      final fileName = segments.isNotEmpty ? segments.last : imageUrl;
      log('Deleting image: $fileName');
      await _supabase.storage.from(bucket ?? bucketName).remove([fileName]);
    } catch (e) {
      log('Error deleting image: $e');
    }
  }
}
