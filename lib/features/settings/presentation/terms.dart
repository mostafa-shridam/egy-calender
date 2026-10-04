import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/remote_settings.dart';
import 'widgets/legal_page_widget.dart';

class TermsOfServicePage extends ConsumerWidget {
  const TermsOfServicePage({super.key});

  static const routeName = '/terms_of_service';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsServicesProvider);
    final terms = state.value?.terms ?? [];
    return state.isLoading
        ? Scaffold(body: const Center(child: CircularProgressIndicator()))
        : terms.isEmpty || state.hasError
        ? Scaffold(body: Center(child: Text('No terms found.')))
        : LegalPage(
          title: LocaleKeys.terms_of_service_page_title.tr(),
          lastUpdated: state.value?.terms.last.date ?? '',
          sections: List.generate(terms.length, (index) {
            final section = terms[index];
            return LegalSection(
              title: section.title(context),
              content: section.subtitle(context),
            );
          }),
        );
  }
}
