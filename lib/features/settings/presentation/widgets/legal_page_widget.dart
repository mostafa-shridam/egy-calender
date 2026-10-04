import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:calender/core/extension/theme_extenison.dart';

import '../../../../core/helper/help_functions.dart';

class LegalPage extends StatelessWidget {
  final String title;
  final List<LegalSection> sections;
  final String? lastUpdated;

  const LegalPage({
    super.key,
    required this.title,
    required this.sections,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (lastUpdated != null) ...[
              const SizedBox(height: 8),
              Text(
                '${LocaleKeys.lastUpdate.tr()} ${formatDateTime(lastUpdated!, context)}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
            const SizedBox(height: 20),
            ...sections.map((section) => _LegalSectionWidget(section: section)),
          ],
        ),
      ),
    );
  }
}

class LegalSection {
  final String title;
  final String content;

  const LegalSection({required this.title, required this.content});
}

class _LegalSectionWidget extends StatelessWidget {
  final LegalSection section;

  const _LegalSectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            section.content,
            style: context.textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
