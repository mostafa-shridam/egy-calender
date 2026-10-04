import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NewsResponse {
  final String? hash;
  final List<NewsModel>? data;

  NewsResponse({this.hash, this.data});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      hash: json['hash'],
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((i) => NewsModel.fromJson(i))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'hash': hash, 'data': data?.map((i) => i.toJson()).toList()};
  }
}

class NewsModel {
  String? id;
  // النصوص بالعربي
  final String? titleAr;
  final String? descriptionAr;
  final String? contentAr;
  final String? sourceNameAr;
  // النصوص بالإنجليزي
  final String? titleEn;
  final String? descriptionEn;
  final String? contentEn;
  final String? sourceNameEn;

  final String? imageUrl;
  final String? sourceLogo;
  final String? author;
  final String? categoryId;
  final String? publishedAt;
  final String? newsUrl;

  NewsModel({
    this.id,
    this.titleAr,
    this.descriptionAr,
    this.contentAr,
    this.sourceNameAr,
    this.titleEn,
    this.descriptionEn,
    this.contentEn,
    this.sourceNameEn,
    this.imageUrl,
    this.sourceLogo,
    this.author,
    this.categoryId,
    this.publishedAt,
    this.newsUrl,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      titleAr: json['title_ar'],
      descriptionAr: json['description_ar'],
      contentAr: json['content_ar'],
      sourceNameAr: json['source_name_ar'],
      titleEn: json['title_en'],
      descriptionEn: json['description_en'],
      contentEn: json['content_en'],
      sourceNameEn: json['source_name_en'],
      imageUrl: json['image_url'],
      sourceLogo: json['source_logo'],
      author: json['author'],
      categoryId: json['categoryId'],
      publishedAt: json['published_at'],
      newsUrl: json['news_url'],
    );
  }
  String? title(BuildContext context) {
    final data = {'ar': titleAr, 'en': titleEn};
    return data[context.locale.languageCode] ?? titleEn;
  }
  
  String? description(BuildContext context) {
    final data = {'ar': descriptionAr, 'en': descriptionEn};
    return data[context.locale.languageCode] ?? descriptionEn;
  }

  String? content(BuildContext context) {
    final data = {'ar': contentAr, 'en': contentEn};
    return data[context.locale.languageCode] ?? contentEn;
  }

  String? sourceName(BuildContext context) {
    final data = {'ar': sourceNameAr, 'en': sourceNameEn};
    return data[context.locale.languageCode] ?? sourceNameEn;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'description_ar': descriptionAr,
      'content_ar': contentAr,
      'source_name_ar': sourceNameAr,
      'title_en': titleEn,
      'description_en': descriptionEn,
      'content_en': contentEn,
      'source_name_en': sourceNameEn,
      'image_url': imageUrl,
      'source_logo': sourceLogo,
      'author': author,
      'categoryId': categoryId,
      'published_at': publishedAt,
      'news_url': newsUrl,
    };
  }
}
