import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'news_model.dart';

class NewsCategoryResponse {
  final String? hash;
  final List<NewsCategoryModel>? data;

  NewsCategoryResponse({this.hash, this.data});

  factory NewsCategoryResponse.fromJson(Map<String, dynamic> json) {
    return NewsCategoryResponse(
      hash: json['hash'],
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((i) => NewsCategoryModel.fromJson(i))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'hash': hash, 'data': data?.map((i) => i.toJson()).toList()};
  }
}

class NewsCategoryModel {
  String? id;
  final String? nameAr;
  final String? nameEn;
  final int? color;
  final String? createdAt;
  final String? updatedAt;
  final List<NewsModel>? news;

  NewsCategoryModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.color,
    this.createdAt,
    this.updatedAt,
    this.news,
  });

  factory NewsCategoryModel.fromJson(Map<String, dynamic> json) {
    return NewsCategoryModel(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      color: json['color'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      news:
          json['news'] != null
              ? (json['news'] as List)
                  .map((i) => NewsModel.fromJson(i))
                  .toList()
              : null,
    );
  }
  String? name(BuildContext context) {
    final data = {'ar': nameAr, 'en': nameEn};
    return data[context.locale.languageCode] ?? nameEn;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'color': color,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'news': news?.map((i) => i.toJson()).toList(),
    };
  }
}
