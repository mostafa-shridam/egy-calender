import 'dart:convert';
import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/constants_enums.dart';
import '../../../../core/local_services/local_storage.dart';
import '../../../../core/repositories/settings/settings_repo.dart';
import '../../../../core/repositories/settings/settings_repo_impl.dart';
import '../models/privacy_policy.dart';
import '../models/terms.dart';
import '../models/version.dart';
part 'generated/remote_settings.g.dart';

@riverpod
class SettingsServices extends _$SettingsServices {
  late SettingsRepo _repo;
  late LocalStorage _localStorage;
  @override
  Future<SettingsServicesStates> build() async {
    _repo = SettingsRepoImpl();
    _localStorage = LocalStorage.instance;
    return _getFromLocal();
  }

  SettingsServicesStates _getFromLocal() {
    final termsRaw = _localStorage.get(Constants.terms.name);
    final privacyRaw = _localStorage.get(Constants.privacyPolicy.name);
    final versionRaw = _localStorage.get(Constants.version.name);

    if (termsRaw == null || privacyRaw == null || versionRaw == null) {
      throw Exception('Local cache is empty');
    }
    final terms =
        (jsonDecode(termsRaw) as List)
            .map((e) => TermsModel.fromJson(e))
            .toList();
    final privacyPolicy =
        (jsonDecode(privacyRaw) as List)
            .map((e) => PrivacyPolicyModel.fromJson(e))
            .toList();
    final version = VersionModel.fromJson(jsonDecode(versionRaw));
    log('version : ${version.toJson(toLocale: true)}');
    return SettingsServicesStates(
      terms: terms,
      privacyPolicy: privacyPolicy,
      version: version,
    );
  }

  Future<SettingsServicesStates> getFromServer() async {
    final terms = await _repo.getTerms();
    final privacyPolicy = await _repo.getPrivacyPolicy();
    final version = await getVersionInfo('1');
    _localStorage.add(
      Constants.version.name,
      jsonEncode(version.toJson(toLocale: true)),
    );
    return SettingsServicesStates(
      terms: terms,
      privacyPolicy: privacyPolicy,
      version: version,
    );
  }

  Future<VersionModel> getVersionInfo(String hash) async {
    try {
      log('start getHashCode');

      final version = await _repo.getVersionById(hash);
      return version;
    } catch (e) {
      log(e.toString());
      return await _repo.getVersionById(hash);
    }
  }
}

class SettingsServicesStates {
  final List<TermsModel> terms;
  final List<PrivacyPolicyModel> privacyPolicy;
  // final List<HelpCenterModel> helpCenter;
  final VersionModel version;

  SettingsServicesStates({
    required this.terms,
    required this.privacyPolicy,
    // required this.helpCenter,
    required this.version,
  });

  SettingsServicesStates copyWith({
    List<TermsModel>? terms,
    List<PrivacyPolicyModel>? privacyPolicy,
    // List<HelpCenterModel>? helpCenter,
    VersionModel? version,
  }) {
    return SettingsServicesStates(
      terms: terms ?? this.terms,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      // helpCenter: helpCenter ?? this.helpCenter,
      version: version ?? this.version,
    );
  }
}
