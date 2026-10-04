import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
class EventSection {
  final String? id;
  final String categoryId;
  final String titleAr;
  final String titleEn;
  final String? createdAt;
  final String? updatedAt;
  EventSection({
    this.id,
    required this.categoryId,
    required this.titleAr,
    required this.titleEn,
    this.createdAt,
    this.updatedAt,
  });

  factory EventSection.fromJson(Map<String, dynamic> json) {
    return EventSection(
      id: json['id']?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      titleAr: json['title_Ar'] ?? '',
      titleEn: json['title_En'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson({bool withId = false}) => {
    if (withId) 'id': id,
    'categoryId': categoryId,
    'title_Ar': titleAr,
    'title_En': titleEn,
    'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    'updatedAt': updatedAt ?? DateTime.now().toIso8601String(),
  };
  String title(BuildContext context) {
    final locale = context.locale.languageCode;
    final data = {'ar': titleAr, 'en': titleEn};

    return data[locale] ?? titleEn;
  }

}
