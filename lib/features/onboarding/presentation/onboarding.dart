import 'package:calender/core/theme/theme_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../splash/data/providers/initial_data_provider.dart';
import '../data/providers/onboarding.dart';
import 'widgets/item.dart';
import 'widgets/onboarding_footer.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  static const routeName = '/onboarding';

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(initialDataLoaderProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.directional(
            textDirection: TextDirection.rtl,
            top: -80,
            end: -80,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: graySwatch.shade300,
            ),
          ),
          Positioned.fill(
            top: -42,
            child: PageView.builder(
              controller: ref.watch(onboardingProvider.notifier).pageController,
              onPageChanged: (value) {
                ref.read(onboardingProvider.notifier).onPageChanged(value);
              },
              itemCount: onboardingItems.length,
              itemBuilder: (context, index) {
                final item = onboardingItems[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    right: 24.0,
                    left: 24,
                    bottom: 160,
                  ),
                  child: Image.asset(item.image, fit: BoxFit.contain),
                );
              },
            ),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: OnboardingFooter()),
        ],
      ),
    );
  }
}
