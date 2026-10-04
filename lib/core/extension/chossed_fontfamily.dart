import 'package:easy_localization/easy_localization.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/locale_keys.g.dart';

enum AppFontFamily {
  montserrat,
  ibmPlex,
  cairo;

  String get fontFamily {
    switch (this) {
      case montserrat:
        return FontFamily.montserrat;
      case ibmPlex:
        return FontFamily.iBMPlexSansArabic;
      case cairo:
        return FontFamily.cairo;
    }
  }

  String get toStr {
    switch (this) {
      case montserrat:
        return FontFamily.montserrat;
      case ibmPlex:
        return FontFamily.iBMPlexSansArabic;
      case cairo:
        return FontFamily.cairo;
    }
  }

  String get translate {
    switch (this) {
      case montserrat:
        return LocaleKeys.oldFont.tr();
      case ibmPlex:
        return LocaleKeys.newFont.tr();
      case cairo:
        return 'Cairo';
    }
  }

  static AppFontFamily fromString(String? family) {
    switch (family) {
      case FontFamily.montserrat:
        return AppFontFamily.montserrat;
      case FontFamily.iBMPlexSansArabic:
        return AppFontFamily.ibmPlex;
      case FontFamily.cairo:
        return AppFontFamily.cairo;
      default:
        return AppFontFamily.cairo;
    }
  }
}
