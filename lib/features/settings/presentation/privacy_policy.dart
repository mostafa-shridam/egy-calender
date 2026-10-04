import 'package:calender/features/settings/data/providers/remote_settings.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/legal_page_widget.dart';

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  static const routeName = '/privacy_policy';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsServicesProvider);
    final privacyPolicy = state.value?.privacyPolicy ?? [];
    return state.isLoading
        ? Scaffold(body: const Center(child: CircularProgressIndicator()))
        : state.hasError
        ? Scaffold(body: const Center(child: Text('No privacy policy found.')))
        : LegalPage(
          title: LocaleKeys.privacyPolicy.tr(),
          lastUpdated: privacyPolicy.last.date,
          sections: List.generate(privacyPolicy.length, (index) {
            final section = privacyPolicy[index];
            return LegalSection(
              title: section.title(context),
              content: section.subtitle(context),
            );
          }),
        );
  }
}
