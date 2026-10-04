import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TermsModel {
  final String? id;
  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final String date;

  TermsModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.date,
  });

  factory TermsModel.fromJson(Map<String, dynamic> json) {
    return TermsModel(
      id: json[r'$id']?.toString() ?? '',
      titleAr: json['titleAr'] ?? '',
      titleEn: json['titleEn'] ?? '',
      subtitleAr: json['subtitleAr'] ?? '',
      subtitleEn: json['subtitleEn'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson({bool toLocale = false}) => {
    if (toLocale) r'$id': id,
    'titleAr': titleAr,
    'titleEn': titleEn,
    'subtitleAr': subtitleAr,
    'subtitleEn': subtitleEn,
    'date': date,
  };
  String title(BuildContext context) {
    final locale = context.locale.languageCode;
    final data = {'ar': titleAr, 'en': titleEn};
    return data[locale] ?? titleEn;
  }

  String subtitle(BuildContext context) {
    final locale = context.locale.languageCode;
    final data = {'ar': subtitleAr, 'en': subtitleEn};
    return data[locale] ?? subtitleEn;
  }
}
