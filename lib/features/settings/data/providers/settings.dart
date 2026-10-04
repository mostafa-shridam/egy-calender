import 'dart:convert';
import 'dart:developer';

import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/helpers/home_widget_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/enums/constants_enums.dart';
import '../../../../core/extension/chossed_fontfamily.dart';
import '../../../../core/extension/font_size.dart';
import '../../../../core/extension/language.dart';
import '../../../../core/extension/theme_mode.dart';
import '../../../../core/local_services/local_storage.dart';
import '../../../../core/notifications/notification_initializer.dart';
part 'generated/settings.g.dart';

@riverpod
class Settings extends _$Settings {
  late final LocalStorage _localStorage;
  @override
  SettingsState build() {
    _localStorage = LocalStorage.instance;

    final lang = _localStorage.get(Constants.language.name);
    final theme = _localStorage.get(Constants.themeMode.name);
    final fontSize = _localStorage.get(Constants.fontSize.name);
    final fontFamily = _localStorage.get(Constants.fontFamily.name);
    final notifications = _localStorage.get(Constants.notifications.name);
    final widgetType = _localStorage.get(Constants.homeWidgetType.name);
    Future.microtask(() => updateHomeWidget());
    return SettingsState(
      language: Language.fromString(lang),
      mode: ThemeModeExtension.fromString(theme),
      fontSize: FontSizes.fromString(fontSize),
      fontFamily: AppFontFamily.fromString(fontFamily),
      notifications: notifications ?? false,
      widgetType: widgetType ?? WidgetDataType.events,
    );
  }

  void changeLanguage(Language language, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      context.setLocale(language.locale ?? Locale(getLanguageCodeHelper()));

      await _localStorage.add(Constants.language.name, language.toStr);
      state = state.copyWith(isLoading: false, language: language);
      updateHomeWidget();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void changeThemeMode(ThemeMode mode) async {
    state = state.copyWith(isLoading: true);
    try {
      await _localStorage.add(Constants.themeMode.name, mode.toStr);
      state = state.copyWith(isLoading: false, mode: mode);
      updateHomeWidget();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void changeFontSize(FontSizes fontSize) async {
    state = state.copyWith(isLoading: true);
    try {
      await _localStorage.add(Constants.fontSize.name, fontSize.toStr);
      state = state.copyWith(isLoading: false, fontSize: fontSize);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void changeFontFamily(AppFontFamily fontFamily) async {
    state = state.copyWith(isLoading: true);
    try {
      await _localStorage.add(Constants.fontFamily.name, fontFamily.toStr);
      state = state.copyWith(isLoading: false, fontFamily: fontFamily);
      updateHomeWidget();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void changeNotifications(bool notifications) async {
    state = state.copyWith(isLoading: true);
    try {
      await _localStorage.add(Constants.notifications.name, notifications);
      ref
          .watch(notificationInitializerProvider)
          .changeNotificationPermission(notifications);
      state = state.copyWith(isLoading: false, notifications: notifications);
      updateHomeWidget();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void changeWidgetType(WidgetDataType type) async {
    state = state.copyWith(isLoading: true);
    try {
      await _localStorage.add(Constants.homeWidgetType.name, type);

      state = state.copyWith(isLoading: false, widgetType: type);
      updateHomeWidget();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateHomeWidget() async {
    final settingsJson = jsonEncode(state.toJson());
    await HomeWidgetService.saveWidgetSettings(settingsJson);
    log('Settings Updated Successfully : $settingsJson');
  }
}

class SettingsState {
  final bool isLoading;
  final ThemeMode mode;
  final FontSizes fontSize;
  final Language language;
  final AppFontFamily fontFamily;
  final bool notifications;
  final WidgetDataType widgetType;
  SettingsState({
    this.isLoading = false,
    this.mode = ThemeMode.system,
    this.fontSize = FontSizes.normal,
    required this.language,
    this.fontFamily = AppFontFamily.cairo,
    this.notifications = true,
    this.widgetType = WidgetDataType.events,
  });

  SettingsState copyWith({
    bool? isLoading,
    ThemeMode? mode,
    FontSizes? fontSize,
    Language? language,
    AppFontFamily? fontFamily,
    bool? notifications,
    WidgetDataType? widgetType,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      mode: mode ?? this.mode,
      fontSize: fontSize ?? this.fontSize,
      language: language ?? this.language,
      fontFamily: fontFamily ?? this.fontFamily,
      notifications: notifications ?? this.notifications,
      widgetType: widgetType ?? this.widgetType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "theme":
          mode == ThemeMode.system
              ? (WidgetsBinding
                          .instance
                          .platformDispatcher
                          .platformBrightness ==
                      Brightness.dark
                  ? "dark"
                  : "light")
              : (mode == ThemeMode.dark ? "dark" : "light"),
      "language": language.toStr, // اتأكد إنها بترجع "ar" أو "en"
      "fontFamily": fontFamily.toStr,
      "fontSizeMultiplier":
          fontSize == FontSizes.small
              ? 0.8
              : (fontSize == FontSizes.large ? 1.2 : 1.0),
      "widgetType": widgetType.name,
    };
  }
}
