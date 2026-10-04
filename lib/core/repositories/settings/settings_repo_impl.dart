import 'dart:convert';
import 'dart:developer';

import 'package:calender/core/enums/constants_enums.dart';
import '../../../features/settings/data/models/privacy_policy.dart';
import '../../../features/settings/data/models/terms.dart';
import '../../../features/settings/data/models/version.dart';
import '../../config/secrets.dart';
import '../../local_services/local_storage.dart';
import '../../remote_services/api_result.dart';
import '../../remote_services/api_service.dart';
import '../../remote_services/dio_client.dart';
import 'settings_repo.dart';

class SettingsRepoImpl implements SettingsRepo {
  final ApiService apiService = ApiService(DioClient(baseUrl: Secrets.baseUrl));
  final LocalStorage _storage = LocalStorage.instance;
  // privacy policy
  @override
  Future<void> addPrivacyPolicy(PrivacyPolicyModel privacyPolicy) async {
    try {
      final result = await apiService.post<PrivacyPolicyModel>(
        '${Secrets.baseUrl}/PrivacyPolicy',
        privacyPolicy.toJson(),
        fromJson: (data) => PrivacyPolicyModel.fromJson(data),
      );

      if (result is Success<PrivacyPolicyModel>) {
        result.data;
      } else {
        throw Exception('Failed to add privacy policy');
      }
    } catch (e) {
      log('Error adding privacy policy: $e');
      rethrow;
    }
  }

  @override
  Future<void> updatePrivacyPolicy(PrivacyPolicyModel privacyPolicy) async {
    try {
      final result = await apiService.put<PrivacyPolicyModel>(
        '${Secrets.baseUrl}/PrivacyPolicy/${privacyPolicy.id}',
        privacyPolicy.toJson(),
        fromJson: (data) => PrivacyPolicyModel.fromJson(data),
      );

      if (result is Success<PrivacyPolicyModel>) {
        result.data;
      } else {
        throw Exception('Failed to update privacy policy');
      }
    } catch (e) {
      log('Error updating privacy policy: $e');
      rethrow;
    }
  }

  @override
  Future<void> deletePrivacyPolicy(String id) async {
    try {
      final result = await apiService.delete<PrivacyPolicyModel>(
        '${Secrets.baseUrl}/PrivacyPolicy/$id',
        id,
        fromJson: (data) => PrivacyPolicyModel.fromJson(data),
      );

      if (result is Success<PrivacyPolicyModel>) {
        result.data;
      } else {
        throw Exception('Failed to update privacy policy');
      }
    } catch (e) {
      log('Error updating privacy policy: $e');
      rethrow;
    }
  }

  @override
  Future<List<PrivacyPolicyModel>> getPrivacyPolicy() async {
    try {
      final result = await apiService.get<List<PrivacyPolicyModel>>(
        '${Secrets.baseUrl}/PrivacyPolicy',
        fromJson: (data) {
          if (data is Map && data.containsKey(r'$values')) {
            final List listData = data[r'$values'];
            final list =
                listData.map((e) => PrivacyPolicyModel.fromJson(e)).toList();

            return list;
          } else {
            return [];
          }
        },
      );
      if (result is Success<List<PrivacyPolicyModel>>) {
        _storage.add(
          Constants.privacyPolicy.name,
          jsonEncode(result.data.map((e) => e.toJson(toLocale: true)).toList()),
        );
        return result.data;
      } else {
        throw Exception(
          'Failed to get privacy policy: ${(result as Failure).error}',
        );
      }
    } catch (e) {
      log('Error getting privacy policy: $e');
      throw Exception('Error getting privacy policy: $e');
    }
  }

  // terms
  @override
  Future<void> addTerms(TermsModel terms) async {
    try {
      final result = await apiService.post<TermsModel>(
        '${Secrets.baseUrl}/TermsOfService',
        terms.toJson(),
        fromJson: (data) => TermsModel.fromJson(data),
      );

      if (result is Success<TermsModel>) {
        result.data;
      } else {
        throw Exception('Failed to add terms');
      }
    } catch (e) {
      log('Error adding terms: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateTerms(TermsModel terms) async {
    try {
      final result = await apiService.put<TermsModel>(
        '${Secrets.baseUrl}/TermsOfService/${terms.id}',
        terms.toJson(),
        fromJson: (data) => TermsModel.fromJson(data),
      );

      if (result is Success<TermsModel>) {
        result.data;
      } else {
        throw Exception('Failed to update terms');
      }
    } catch (e) {
      log('Error updating terms: $e');
      rethrow;
    }
  }

  @override
  Future<List<TermsModel>> getTerms() async {
    try {
      final result = await apiService.get<List<TermsModel>>(
        '${Secrets.baseUrl}/TermsOfService',
        fromJson: (data) {
          if (data is Map && data.containsKey(r'$values')) {
            final List listData = data[r'$values'];
            final list = listData.map((e) => TermsModel.fromJson(e)).toList();

            return list;
          } else {
            return [];
          }
        },
      );
      if (result is Success<List<TermsModel>>) {
        _storage.add(
          Constants.terms.name,
          jsonEncode(result.data.map((e) => e.toJson(toLocale: true)).toList()),
        );
        return result.data;
      } else {
        throw Exception('Failed to get terms: ${(result as Failure).error}');
      }
    } catch (e) {
      log('Error getting terms: $e');
      throw Exception('Error getting terms: $e');
    }
  }

  //version
  @override
  Future<void> addVersion(VersionModel version) async {
    try {
      final result = await apiService.post<VersionModel>(
        '${Secrets.baseUrl}/Versions',
        version.toJson(),
        fromJson: (data) => VersionModel.fromJson(data),
      );

      if (result is Success<VersionModel>) {
        result.data;
      } else {
        throw Exception('Failed to add version');
      }
    } catch (e) {
      log('Error adding version: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateVersion(VersionModel version) async {
    try {
      // 1. تأكد من المسار (تجنب الـ double slashes)
      final url =
          '${Secrets.baseUrl.endsWith('/') ? Secrets.baseUrl.substring(0, Secrets.baseUrl.length - 1) : Secrets.baseUrl}/Versions/${version.id}';

      log('📡 Attempting update on: $url');
      log('📦 Body: ${jsonEncode(version.toJson())}');

      final result = await apiService.put<VersionModel>(
        '${Secrets.baseUrl}/Versions/${version.id}',
        version.toJson(),
        fromJson: (json) {
          // السيرفر بيرجع الـ object جوه حقل اسمه 'data'
          if (json is Map && json.containsKey('data')) {
            return VersionModel.fromJson(json['data']);
          }
          // لو السيرفر بعت الـ object مباشرة (للاحتياط)
          return VersionModel.fromJson(json);
        },
      );

      if (result is Success<VersionModel>) {
        log('✅ Version updated successfully on server');
      } else if (result is Failure) {
        // 2. اطبع الـ error اللي جاي من السيرفر فعلياً (ده اللي هيقولنا الحقيقة)
        log('❌ Server rejected update: ${(result as Failure).error}');
        throw Exception('Server Error: $result');
      }
    } catch (e) {
      log('🔥 Crash in updateVersion: $e');
      rethrow;
    }
  }

  @override
  Future<VersionModel> getVersionById(String id) async {
    try {
      final result = await apiService.get<VersionModel>(
        '${Secrets.baseUrl}/Versions/$id',
        fromJson: (data) => VersionModel.fromJson(data),
      );
      if (result is Success<VersionModel>) {
        return result.data;
      } else {
        throw Exception('Failed to get version: ${(result as Failure).error}');
      }
    } catch (e) {
      log('Error getting version: $e');
      throw Exception('Error getting version: $e');
    }
  }
}
