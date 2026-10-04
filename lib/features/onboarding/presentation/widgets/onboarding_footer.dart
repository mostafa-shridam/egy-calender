import 'package:calender/core/theme/theme_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extension/theme_extenison.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/providers/onboarding.dart';
import 'item.dart';

class OnboardingFooter extends ConsumerWidget {
  const OnboardingFooter({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(onboardingProvider.select((v) => v.page));
    final isDark = Theme.of(context).isDark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        color: isDark ? graySwatch.shade600 : graySwatch.shade100,
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              onboardingItems[index].title,
              style: context.textTheme.titleLarge,
            ),
            Text(
              onboardingItems[index].description,
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                for (int i = 0; i < onboardingItems.length; i++)
                  Container(
                    height: 12,
                    width: index == i ? 24 : 12,
                    decoration: BoxDecoration(
                      color:
                          index == i
                              ? AppColors.primaryColor
                              : AppColors.accentColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
            CustomButton(
              text: onboardingItems[index].buttonTitle,
              onPressed: () {
                ref.watch(onboardingProvider.notifier).nextPage(context);
              },
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
