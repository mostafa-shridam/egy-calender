import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EventModel {
  final String? id;
  final String? categoryId;
  final String? sectionId;
  final String? titleAr;
  final String? titleEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? locationAr;
  final String? locationEn;
  final String? image;
  final String? date;
  final String? createdAt;
  final String? updatedAt;

  EventModel({
    this.id,
    this.categoryId,
    this.sectionId,
    this.titleAr,
    this.titleEn,
    this.descriptionAr,
    this.descriptionEn,
    this.locationAr,
    this.locationEn,
    this.image,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json['id']?.toString() ?? '',
    categoryId: json['categoryId']?.toString() ?? '',
    sectionId: json['sectionId']?.toString() ?? '',
    titleAr: json['title_Ar'] ?? '',
    titleEn: json['title_En'] ?? '',
    descriptionAr: json['description_Ar'] ?? '',
    descriptionEn: json['description_En'] ?? '',
    locationAr: json['location_Ar'] ?? '',
    locationEn: json['location_En'] ?? '',
    image: json['image'] ?? '',
    date: json['date'] ?? '',
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
  );

  Map<String, dynamic> toJson({bool toLocale = false}) => {
    if (toLocale) 'id': id,
    'categoryId': categoryId,
    'sectionId': sectionId,
    'title_Ar': titleAr,
    'title_En': titleEn,
    'description_Ar': descriptionAr,
    'description_En': descriptionEn,
    'location_Ar': locationAr,
    'location_En': locationEn,
    'image': image,
    'date': date,
    if (!toLocale) 'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    if (!toLocale) 'UpdatedAt': DateTime.now().toIso8601String(),
    if (toLocale) 'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    if (toLocale) 'updatedAt': updatedAt ?? DateTime.now().toIso8601String(),
  };
  String title(BuildContext context) {
    final locale = context.locale.languageCode;
    final data = {'ar': titleAr, 'en': titleEn};
    return data[locale] ?? titleEn!;
  }

  String description(BuildContext context) {
    final locale = context.locale.languageCode;
    final data = {'ar': descriptionAr, 'en': descriptionEn};
    return data[locale] ?? descriptionEn!;
  }

  String location(BuildContext context) {
    final locale = context.locale.languageCode;
    final data = {'ar': locationAr, 'en': locationEn};
    return data[locale] ?? locationEn!;
  }
}
