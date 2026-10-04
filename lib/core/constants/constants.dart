import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

const appName = "Calender";
const translationsPath = 'assets/translations';
const supportedLocales = [Locale('en'), Locale('ar')];
const dateFormat = 'EEE,d MMM, yyyy • h:mm a';
String atDateFormat = 'dd MMM, yyyy \'${LocaleKeys.at.tr()}\' h:mm a';
const dateOnlyFormat = 'EEE, d MMM yyyy';
// Primary colors list for selection
const List<Color> colorsToPick = [
  AppColors.primaryColor,
  AppColors.accentColor,
  AppColors.successGreen,
  AppColors.warningYellow,
  AppColors.dangerRed,
  Colors.purple,
  Colors.teal,
  Colors.orange,
  Colors.pink,
  Colors.indigo,
];
