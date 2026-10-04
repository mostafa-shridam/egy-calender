import 'package:calender/core/widgets/my_text_filed.dart';
import 'package:calender/features/dashboard/presentation/widgets/settings/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../settings/data/models/version.dart';
import '../data/providers/settings.dart';
import 'widgets/settings/privacy_policy.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final TextEditingController versionController = TextEditingController();

  @override
  void dispose() {
    versionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final version = ref.watch(settingsProvider.select((e) => e.value?.version));
    versionController.text = version?.version ?? '';
    return Column(
      children: [
        ListTile(
          title: const Text('Privacy Policy'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            context.pushNamed(PrivacyPolicy.routeName);
          },
        ),
        ListTile(
          title: const Text('Terms'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            context.pushNamed(Terms.routeName);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Version'),
              const Spacer(),
              SizedBox(
                width: 300,
                child: MyTextField(controller: versionController),
              ),
              const SizedBox(width: 60),

              TextButton(
                onPressed: () async {
                  final versionModel = VersionModel(
                    version: versionController.text,
                    id: version?.id,
                  );
                  await ref
                      .read(settingsProvider.notifier)
                      .updateVersion(versionModel);
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
