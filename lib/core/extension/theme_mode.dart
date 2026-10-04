import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';

extension ThemeModeExtension on ThemeMode {
  static ThemeMode fromString(String? mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  String get translate {
    switch (this) {
      case ThemeMode.light:
        return LocaleKeys.lightMode.tr();
      case ThemeMode.dark:
        return LocaleKeys.darkMode.tr();
      case ThemeMode.system:
        return LocaleKeys.auto.tr();
    }
  }

  String get toStr {
    switch (this) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
