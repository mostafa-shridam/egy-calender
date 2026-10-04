import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const routeName = '/help_center';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.helpCenter.tr())),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const _FaqTile(
                question: 'How do I add a new event?',
                answer: 'Go to the "My Events" tab and tap the + button.',
              ),
              const _FaqTile(
                question: 'Can I change the theme?',
                answer:
                    'Yes, go to Settings > Theme Mode to switch between Light, Dark, and System modes.',
              ),
              const _FaqTile(
                question: 'Is my data backed up?',
                answer:
                    'Yes! Your data is stored locally and securely synced to the cloud when you log in.',
              ),
              const _FaqTile(
                question: 'How do I contact support?',
                answer:
                    'You can contact us via the "Contact Us" page in Settings.',
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'App Version: v1.0.0',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        iconColor: Theme.of(context).greySwatch,
        title: Text(question, style: context.textTheme.titleMedium),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(answer, style: context.textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
