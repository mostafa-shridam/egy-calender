import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'event_model.dart';

class EventCategory {
  final String? id;
  final String nameAr;
  final String nameEn;
  final int color;
  final String? createdAt;
  final String? updatedAt;
  final List<EventModel> events;

  EventCategory({
    this.id,
    required this.nameAr,
    required this.nameEn,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    this.events = const [],
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      id: json['id']?.toString() ?? '',
      nameAr: json['name_Ar'] ?? '',
      nameEn: json['name_En'] ?? '',
      color: json['color'] as int? ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      events: [],
    );
  }

  // للتخزين المحلي (Cache)
  Map<String, dynamic> toJson({bool withId = false}) => {
    if (withId) 'id': id,
    "name_Ar": nameAr,
    "name_En": nameEn,
    "color": color,
    "createdAt": createdAt ?? DateTime.now().toIso8601String(),
    "updatedAt": updatedAt ?? DateTime.now().toIso8601String(),
    "events": events.map((e) => e.toJson()).toList(),
  };
  String name(BuildContext context) {
    final locale = context.locale.languageCode;
    final data = {'ar': nameAr, 'en': nameEn};
    return data[locale] ?? nameEn;
  }
}
