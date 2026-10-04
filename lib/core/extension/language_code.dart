extension LanguageNameFromCode on String {
  String? get languageName {
    switch (this) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
    }
    return null;
  }
}
