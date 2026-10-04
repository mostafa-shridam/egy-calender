import 'package:calender/core/extension/language.dart';
import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/core/theme/app_colors.dart';
import 'package:calender/features/dashboard/presentation/category_view.dart';
import 'package:calender/features/dashboard/presentation/event_view.dart';
import 'package:calender/features/dashboard/presentation/news_category.dart';
import 'package:calender/features/dashboard/presentation/price_view.dart';
import 'package:calender/features/dashboard/presentation/section_view.dart';
import 'package:calender/features/settings/data/providers/settings.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../login/data/providers/auth.dart';
import 'news_view.dart';
import 'settings_view.dart';

class DashboardPage extends ConsumerWidget with AlertMixin {
  const DashboardPage({super.key});
  static const String routeName = '/dashboard';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = Theme.of(context).isDark;
    final language = ref.watch(settingsProvider).language;
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              onPressed: () {
                ref
                    .read(settingsProvider.notifier)
                    .changeLanguage(
                      language == Language.engilsh
                          ? Language.arabic
                          : Language.engilsh,
                      context,
                    );
              },
              icon: Icon(Icons.language),
            ),
            IconButton(
              onPressed: () {
                ref
                    .read(settingsProvider.notifier)
                    .changeThemeMode(
                      themeMode ? ThemeMode.light : ThemeMode.dark,
                    );
              },
              icon: Icon(themeMode ? Icons.light_mode : Icons.dark_mode),
            ),

            IconButton(
              onPressed:
                  () => showWarningAlert(
                    context: context,
                    title: 'Logout',
                    message: 'Are you sure you want to logout?',
                    onConfirm:
                        () async => await ref
                            .read(authProvider.notifier)
                            .signOut(context),
                  ),
              icon: Icon(Icons.logout),
            ),
            IconButton(
              onPressed:
                  () => showDangerAlert(
                    context: context,
                    title: 'Delete Account',
                    message: 'Are you sure you want to delete your account?',
                    onConfirm:
                        () async => await ref
                            .read(authProvider.notifier)
                            .deleteAccount(context),
                  ),
              icon: Icon(Icons.delete, color: AppColors.dangerRed),
            ),
            const SizedBox(width: 16),
          ],
          bottom: TabBar(
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.accentColor.withValues(alpha: 0.6),
            indicatorColor: AppColors.primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(icon: Icon(Icons.category), text: 'Categories'),
              Tab(icon: Icon(Icons.view_module), text: 'Sections'),
              Tab(icon: Icon(Icons.event), text: LocaleKeys.events.tr()),
              Tab(icon: Icon(Icons.category_outlined), text: 'News Category'),
              Tab(icon: Icon(Icons.newspaper), text: 'News'),
              Tab(icon: Icon(Icons.price_change_outlined), text: 'Prices'),
              Tab(icon: Icon(Icons.settings), text: LocaleKeys.settings.tr()),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CategoryView(),
            SectionView(),
            EventView(),
            NewsCategoryView(),
            NewsView(),
            PricesView(),
            SettingsView(),
          ],
        ),
      ),
    );
  }
}
