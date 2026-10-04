import 'package:calender/features/settings/data/models/privacy_policy.dart';
import 'package:calender/features/settings/data/models/version.dart';

import '../../../features/settings/data/models/terms.dart';

abstract class SettingsRepo {
  // help center
  // void addHelpCenter(HelpCenterModel helpCenter);
  // void updateHelpCenter(HelpCenterModel helpCenter);
  // Future<List<HelpCenterModel>> getHelpCenter();

  // privacy policy
  Future<void> addPrivacyPolicy(PrivacyPolicyModel privacyPolicy);
  Future<void> updatePrivacyPolicy(PrivacyPolicyModel privacyPolicy);
  Future<List<PrivacyPolicyModel>> getPrivacyPolicy();
  Future<void> deletePrivacyPolicy(String id);

  // terms
  Future<void> addTerms(TermsModel terms);
  Future<void> updateTerms(TermsModel terms);
  Future<List<TermsModel>> getTerms();
  //version
  Future<void> addVersion(VersionModel version);
  Future<void> updateVersion(VersionModel version);
  Future<VersionModel> getVersionById(String id);
}
