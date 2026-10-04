import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';

enum FontSizes {
  small,
  normal,
  large;

  static FontSizes fromString(String? size) {
    switch (size) {
      case 'small':
        return FontSizes.small;
      case 'large':
        return FontSizes.large;
      default:
        return FontSizes.normal;
    }
  }

  static FontSizes fromValue(double value) {
    switch (value.toString()) {
      case '0.8':
        return FontSizes.small;
      case '1.2':
        return FontSizes.large;
      default:
        return FontSizes.normal;
    }
  }

  String get translate {
    switch (this) {
      case FontSizes.small:
        return LocaleKeys.small.tr();
      case FontSizes.normal:
        return LocaleKeys.normal.tr();
      case FontSizes.large:
        return LocaleKeys.large.tr();
    }
  }

  double get value {
    switch (this) {
      case FontSizes.small:
        return 0.8;
      case FontSizes.large:
        return 1.2;
      default:
        return 1.0;
    }
  }

  String get toStr {
    switch (this) {
      case FontSizes.small:
        return 'small';
      case FontSizes.large:
        return 'large';
      default:
        return 'normal';
    }
  }
}
