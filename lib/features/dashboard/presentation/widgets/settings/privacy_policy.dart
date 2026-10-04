import 'dart:developer';

import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/features/dashboard/data/providers/settings.dart';
import 'package:calender/features/dashboard/presentation/widgets/forms/policy_form.dart';
import 'package:calender/features/settings/data/models/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacyPolicy extends ConsumerWidget {
  const PrivacyPolicy({super.key});
  static const routeName = '/privacy-policy';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void showForm(
      BuildContext context,
      WidgetRef ref, {
      PrivacyPolicyModel? model,
    }) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: SizedBox(
                width: 400,
                child: PolicyForm(
                  policyModel: model,
                  onSave: (newEvent) async {
                    if (model == null) {
                      await ref
                          .read(settingsProvider.notifier)
                          .addPrivacyPolicy(newEvent);
                    } else {
                      await ref
                          .read(settingsProvider.notifier)
                          .updatePrivacyPolicy(newEvent);
                    }
                  },
                ),
              ),
            ),
      );
    }

    final state = ref.read(settingsProvider);
    final privacyPolicy = state.value?.privacyPolicy ?? [];
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: state.when(
        data: (policy) {
          if (privacyPolicy.isEmpty) {
            return const Center(child: Text('No privacy policy found.'));
          }
          return Column(
            children: List.generate(privacyPolicy.length, (index) {
              final policy = privacyPolicy[index];
              log('policy id ${policy.id}');
              return ListTile(
                title: Text(
                  policy.title(context),
                  style: context.textTheme.titleMedium,
                ),
                subtitle: Text(
                  policy.subtitle(context),
                  style: context.textTheme.bodyMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showForm(context, ref, model: policy);
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(settingsProvider.notifier)
                            .deletePrivacy(policy.id ?? '');
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            }),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
