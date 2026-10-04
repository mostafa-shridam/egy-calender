import 'package:calender/features/dashboard/data/providers/settings.dart';
import 'package:calender/features/settings/data/models/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/extension/theme_extenison.dart';
import '../forms/terms_form.dart';

class Terms extends ConsumerWidget {
  const Terms({super.key});
  static const routeName = '/terms';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void showForm(BuildContext context, WidgetRef ref, {TermsModel? model}) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              content: SizedBox(
                width: 400,
                child: TermsForm(
                  model: model,
                  onSave: (newEvent) async {
                    if (model == null) {
                      await ref
                          .read(settingsProvider.notifier)
                          .addTerms(newEvent);
                    } else {
                      await ref
                          .read(settingsProvider.notifier)
                          .updateTerms(newEvent);
                    }
                  },
                ),
              ),
            ),
      );
    }

    final state = ref.watch(settingsProvider);
    final terms = state.value?.terms ?? [];
    return Scaffold(
      appBar: AppBar(title: Text('Terms')),
      body:
          state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : terms.isNotEmpty
              ? Column(
                children: List.generate(terms.length, (index) {
                  final term = terms[index];
                  return ListTile(
                    title: Text(
                      term.title(context),
                      style: context.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      term.subtitle(context),
                      style: context.textTheme.bodyMedium,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showForm(context, ref, model: term);
                      },
                      icon: Icon(Icons.edit),
                    ),
                  );
                }),
              )
              : const Center(child: Text('No Terms found.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
