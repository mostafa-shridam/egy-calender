import 'dart:developer';
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/repositories/settings/settings_repo.dart';
import '../../../../core/repositories/settings/settings_repo_impl.dart';
import '../../../settings/data/models/privacy_policy.dart';
import '../../../settings/data/models/terms.dart';
import '../../../settings/data/models/version.dart';
part 'generated/settings.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  late SettingsRepo _repo;

  @override
  FutureOr<SettingsStates> build() async {
    _repo = SettingsRepoImpl();

    // Fetch all data in parallel for better performance
    final results = await Future.wait([
      _repo.getTerms(),
      _repo.getPrivacyPolicy(),
      _repo.getVersionById('1'),
    ]);

    return SettingsStates(
      terms: results[0] as List<TermsModel>,
      privacyPolicy: results[1] as List<PrivacyPolicyModel>,
      version: results[2] as VersionModel,
    );
  }

  /// Add new terms (internet only)
  Future<void> addTerms(TermsModel terms) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.addTerms(terms);
      // Refresh terms after adding
      final updatedTerms = await _repo.getTerms();
      final currentState = state.value;
      await _updateVersion();

      if (currentState != null) {
        return currentState.copyWith(terms: updatedTerms);
      }
      return currentState ?? SettingsStates();
    });
  }

  /// Update terms (internet only)
  Future<void> updateTerms(TermsModel terms) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.updateTerms(terms);
      // Refresh terms after updating
      final updatedTerms = await _repo.getTerms();
      final currentState = state.value;
      await _updateVersion();

      if (currentState != null) {
        return currentState.copyWith(terms: updatedTerms);
      }
      return currentState ?? SettingsStates();
    });
  }

  /// Get all terms (internet only)
  Future<void> getTerms() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final terms = await _repo.getTerms();
      final currentState = state.value;
      if (currentState != null) {
        return currentState.copyWith(terms: terms);
      }
      return currentState ?? SettingsStates();
    });
  }

  /// Add new privacy policy (internet only)
  Future<void> addPrivacyPolicy(PrivacyPolicyModel privacyPolicy) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.addPrivacyPolicy(privacyPolicy);
      // Refresh privacy policy after adding
      final updatedPolicy = await _repo.getPrivacyPolicy();
      await _updateVersion();
      final currentState = state.value;
      if (currentState != null) {
        return currentState.copyWith(privacyPolicy: updatedPolicy);
      }
      return currentState ?? SettingsStates();
    });
  }

  /// Update privacy policy (internet only)
  Future<void> updatePrivacyPolicy(PrivacyPolicyModel privacyPolicy) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.updatePrivacyPolicy(privacyPolicy);
      // Refresh privacy policy after updating
      await _updateVersion();
      final updatedPolicy = await _repo.getPrivacyPolicy();

      final currentState = state.value;
      if (currentState != null) {
        return currentState.copyWith(privacyPolicy: updatedPolicy);
      }
      return currentState ?? SettingsStates();
    });
  }

  /// Get all privacy policies (internet only)
  Future<void> getPrivacyPolicy() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final privacyPolicy = await _repo.getPrivacyPolicy();
      final currentState = state.value;
      if (currentState != null) {
        return currentState.copyWith(privacyPolicy: privacyPolicy);
      }
      return currentState ?? SettingsStates();
    });
  }

  void deletePrivacy(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.deletePrivacyPolicy(id);
      await _updateVersion();
      final updatedVersion = await _repo.getPrivacyPolicy();
      final currentState = state.value;
      if (currentState != null) {
        return currentState.copyWith(privacyPolicy: updatedVersion);
      }
      return currentState ?? SettingsStates();
    });
  }

  /// Update version (internet only)
  Future<void> updateVersion(VersionModel version) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.updateVersion(version);
      final updatedVersion = await _repo.getVersionById(version.id ?? '1');
      final currentState = state.value;
      await _updateVersion();

      if (currentState != null) {
        return currentState.copyWith(version: updatedVersion);
      }
      return currentState ?? SettingsStates();
    });
  }

  /// Get version (internet only)
  Future<void> getVersion(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatedVersion = await _repo.getVersionById(id);
      final currentState = state.value;
      if (currentState != null) {
        return currentState.copyWith(version: updatedVersion);
      }
      return currentState ?? SettingsStates();
    });
  }

  Future<void> _updateVersion() async {
    final newVersion = math.Random().nextInt(1000).toString();
    await _repo.updateVersion(VersionModel(id: '4', version: newVersion));
    log('🔔 Version updated to: $newVersion');
  }
}

class SettingsStates {
  final List<TermsModel>? terms;
  final List<PrivacyPolicyModel>? privacyPolicy;
  final VersionModel? version;

  SettingsStates({
    this.terms,
    this.privacyPolicy,
    this.version,
  });

  SettingsStates copyWith({
    List<TermsModel>? terms,
    List<PrivacyPolicyModel>? privacyPolicy,
    VersionModel? version,
  }) {
    return SettingsStates(
      terms: terms ?? this.terms,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      version: version ?? this.version,
    );
  }
}
