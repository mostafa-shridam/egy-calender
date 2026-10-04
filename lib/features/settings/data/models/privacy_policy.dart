import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyModel {
  String? id;
  final String titleAr;
  final String subTitleAr;
  final String titleEn;
  final String subTitleEn;
  final String date;

  PrivacyPolicyModel({
    required this.id,
    required this.titleAr,
    required this.subTitleAr,
    required this.titleEn,
    required this.subTitleEn,
    required this.date,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      id: json[r'$id']?.toString() ?? '',
      titleAr: json['titleAr'] ?? '',
      subTitleAr: json['subtitleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',
      subTitleEn: json['subtitleEn'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson({bool toLocale = false}) => {
    if (toLocale) r'$id': id,
    'titleAr': titleAr,
    'subtitleAr': subTitleAr,
    'titleEn': titleEn,
    'subtitleEn': subTitleEn,
    'date': date,
  };
  String title(BuildContext context) {
    final locale = context.locale.languageCode;
    final data = {'ar': titleAr, 'en': titleEn};
    return data[locale] ?? titleEn;
  }

  String subtitle(BuildContext context) {
    final locale = context.locale.languageCode;
    final data = {'ar': subTitleAr, 'en': subTitleEn};
    return data[locale] ?? subTitleEn;
  }
}
