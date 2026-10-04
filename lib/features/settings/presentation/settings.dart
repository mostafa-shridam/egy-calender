import 'package:calender/core/extension/font_size.dart';
import 'package:calender/core/extension/theme_mode.dart';
import 'package:calender/core/theme/app_colors.dart';
import 'package:calender/features/login/data/providers/auth.dart';
import 'package:calender/features/settings/data/providers/remote_settings.dart';
import 'package:calender/features/settings/presentation/categories.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extension/chossed_fontfamily.dart';
import '../../../core/extension/language.dart';
import '../../../core/mixins/alert_mixin.dart';
import '../../../core/mixins/bottom_sheet_mixin.dart';
import '../../../helpers/home_widget_helper.dart';
import '../../login/data/providers/save_user.dart';
import '../data/providers/settings.dart';
import 'contact_us.dart';
import 'help_center.dart';
import 'privacy_policy.dart';
import 'terms.dart';
import 'widgets/header.dart';
import 'widgets/profile_widget.dart';
import 'widgets/settings_tile.dart';

class SettingsPage extends ConsumerWidget with BottomSheetMixin, AlertMixin {
  const SettingsPage({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = SaveUser.instance.getUser();
    final settings = ref.watch(settingsProvider);
    final version =
        ref.watch(settingsServicesProvider).value?.version.version ?? '1.0.0';
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.settings.tr())),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(title: LocaleKeys.profileInformations.tr()),
            ProfileWidget(user: user),
            const Divider(height: 0),
            SettingsTile(
              title: LocaleKeys.my_categories.tr(),
              onTap: () => context.pushNamed(CategoriesPage.routeName),
            ),
            SettingsTile(
              title: 'Widget Type',
              onTap: () {
                showCustomBottomSheet(
                  context,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingsTile(
                        title: 'Events',
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeWidgetType(WidgetDataType.events);
                          context.pop();
                        },
                        data: WidgetDataType.events.name,
                        selected: settings.widgetType == WidgetDataType.events,
                      ),
                      SettingsTile(
                        title: 'News',
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeWidgetType(WidgetDataType.news);
                          context.pop();
                        },
                        data: WidgetDataType.news.name,
                        selected: settings.widgetType == WidgetDataType.news,
                      ),

                      SettingsTile(
                        title: 'Prices',
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeWidgetType(WidgetDataType.prices);
                          context.pop();
                        },
                        data: WidgetDataType.prices.name,
                        selected: settings.widgetType == WidgetDataType.prices,
                      ),

                      SettingsTile(
                        title: 'My Events',
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeWidgetType(WidgetDataType.myEvents);
                          context.pop();
                        },
                        data: WidgetDataType.myEvents.name,
                        selected:
                            settings.widgetType == WidgetDataType.myEvents,
                      ),
                    ],
                  ),
                );
              },
            ),
            HeaderWidget(title: LocaleKeys.generalSettings.tr()),
            // Language
            SettingsTile(
              title: LocaleKeys.language.tr(),
              onTap: () {
                showCustomBottomSheet(
                  context,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingsTile(
                        title: 'English',
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeLanguage(Language.engilsh, context);
                          context.pop();
                        },
                        data:
                            Language.fromString(
                              Language.engilsh.toStr,
                            ).translate,
                        selected: settings.language == Language.engilsh,
                      ),
                      SettingsTile(
                        title: 'Arabic',
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeLanguage(Language.arabic, context);
                          context.pop();
                        },
                        data:
                            Language.fromString(
                              Language.arabic.toStr,
                            ).translate,
                        selected: settings.language == Language.arabic,
                      ),
                    ],
                  ),
                );
              },
              data: Language.fromString(settings.language.toStr).translate,
            ),
            // Theme Mode
            SettingsTile(
              title: LocaleKeys.theme.tr(),
              onTap: () {
                showCustomBottomSheet(
                  context,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingsTile(
                        title: LocaleKeys.theme_light.tr(),
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeThemeMode(ThemeMode.light);
                          context.pop();
                        },
                        data: ThemeMode.light.translate,
                        selected: settings.mode == ThemeMode.light,
                      ),
                      SettingsTile(
                        title: LocaleKeys.theme_dark.tr(),
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeThemeMode(ThemeMode.dark);
                          context.pop();
                        },
                        data: ThemeMode.dark.translate,
                        selected: settings.mode == ThemeMode.dark,
                      ),
                      SettingsTile(
                        title: LocaleKeys.theme_system.tr(),
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeThemeMode(ThemeMode.system);
                          context.pop();
                        },
                        data: ThemeMode.system.translate,
                        selected: settings.mode == ThemeMode.system,
                      ),
                    ],
                  ),
                );
              },
              data: settings.mode.translate,
            ),
            // Font Size
            SettingsTile(
              title: LocaleKeys.fontSize.tr(),
              onTap: () {
                showCustomBottomSheet(
                  context,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingsTile(
                        title: FontSizes.small.translate,
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeFontSize(FontSizes.small);
                          context.pop();
                        },
                        data: FontSizes.small.translate,
                        selected: settings.fontSize == FontSizes.small,
                      ),
                      SettingsTile(
                        title: FontSizes.normal.translate,
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeFontSize(FontSizes.normal);
                          context.pop();
                        },
                        data: FontSizes.normal.translate,
                        selected: settings.fontSize == FontSizes.normal,
                      ),
                      SettingsTile(
                        title: FontSizes.large.translate,
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeFontSize(FontSizes.large);
                          context.pop();
                        },
                        data: FontSizes.large.translate,
                        selected: settings.fontSize == FontSizes.large,
                      ),
                    ],
                  ),
                );
              },
              data: FontSizes.fromString(settings.fontSize.toStr).translate,
            ),
            // Font Family
            SettingsTile(
              title: LocaleKeys.fontType.tr(),
              onTap: () {
                showCustomBottomSheet(
                  context,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingsTile(
                        title: LocaleKeys.tryNewFont.tr(),
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeFontFamily(AppFontFamily.cairo);
                          context.pop();
                        },
                        data: AppFontFamily.cairo.translate,
                        selected: settings.fontFamily == AppFontFamily.cairo,
                      ),
                      SettingsTile(
                        title: LocaleKeys.newFont.tr(),
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeFontFamily(AppFontFamily.montserrat);
                          context.pop();
                        },
                        data: AppFontFamily.montserrat.translate,
                        selected:
                            settings.fontFamily == AppFontFamily.montserrat,
                      ),
                      SettingsTile(
                        title: LocaleKeys.oldFont.tr(),
                        onTap: () {
                          ref
                              .watch(settingsProvider.notifier)
                              .changeFontFamily(AppFontFamily.ibmPlex);
                          context.pop();
                        },
                        data: AppFontFamily.ibmPlex.translate,
                        selected: settings.fontFamily == AppFontFamily.ibmPlex,
                      ),
                    ],
                  ),
                );
              },
              data:
                  AppFontFamily.fromString(settings.fontFamily.toStr).translate,
            ),
            // Notifications
            SettingsTile(
              title: LocaleKeys.notifications.tr(),
              onTap: () {
                ref
                    .watch(settingsProvider.notifier)
                    .changeNotifications(!settings.notifications);
              },
              switchValue: settings.notifications,
              switchOnChanged: (value) {
                ref.watch(settingsProvider.notifier).changeNotifications(value);
              },
            ),
            HeaderWidget(title: LocaleKeys.help.tr()),
            SettingsTile(
              title: LocaleKeys.helpCenter.tr(),
              onTap: () {
                context.push(HelpCenterPage.routeName);
              },
            ),
            SettingsTile(
              title: LocaleKeys.contactUs.tr(),
              onTap: () {
                context.push(ContactUsPage.routeName);
              },
            ),
            HeaderWidget(title: LocaleKeys.about.tr()),
            SettingsTile(title: LocaleKeys.version.tr(), data: version),
            SettingsTile(
              title: LocaleKeys.privacyPolicy.tr(),
              onTap: () {
                context.push(PrivacyPolicyPage.routeName);
              },
            ),
            SettingsTile(
              title: LocaleKeys.termsOfService.tr(),
              onTap: () {
                context.push(TermsOfServicePage.routeName);
              },
            ),
            if (user != null) ...[
              HeaderWidget(title: LocaleKeys.account.tr()),
              SettingsTile(
                title: LocaleKeys.logout.tr(),
                onTap: () {
                  showWarningAlert(
                    context: context,
                    title: LocaleKeys.logout.tr(),
                    message: LocaleKeys.are_you_sure_logout.tr(),
                    onConfirm: () {
                      ref.watch(authProvider.notifier).signOut(context);
                    },
                  );
                },
              ),
              SettingsTile(
                title: LocaleKeys.deleteAccount.tr(),
                onTap: () async {
                  showDangerAlert(
                    context: context,
                    title: LocaleKeys.deleteAccount.tr(),
                    message: LocaleKeys.deleteAccountMessage.tr(),
                    onConfirm: () {
                      ref.watch(authProvider.notifier).deleteAccount(context);
                    },
                  );
                },
                color: AppColors.dangerRed,
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
