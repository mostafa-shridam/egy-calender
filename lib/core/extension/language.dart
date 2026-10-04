import 'package:flutter/material.dart';

enum Language {
  engilsh,
  arabic;

  static Language fromString(String? language) {
    switch (language?.toLowerCase()) {
      case 'english':
        return Language.engilsh;
      case 'arabic':
        return Language.arabic;
      default:
        return Language.engilsh;
    }
  }

  String get translate {
    switch (this) {
      case Language.engilsh:
        return 'English';
      case Language.arabic:
        return 'العربية';
    }
  }

  String get toStr {
    switch (this) {
      case Language.engilsh:
        return 'english';
      case Language.arabic:
        return 'arabic';
    }
  }

  Locale? get locale {
    switch (this) {
      case Language.engilsh:
        return const Locale('en');
      case Language.arabic:
        return const Locale('ar');
    }
  }
}
