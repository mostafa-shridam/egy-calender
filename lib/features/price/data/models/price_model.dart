import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PriceResponse {
  final String? hash;
  final List<PriceModel>? data;

  PriceResponse({this.hash, this.data});

  factory PriceResponse.fromJson(Map<String, dynamic> json) {
    return PriceResponse(
      hash: json['hash'],
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((i) => PriceModel.fromJson(i))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'hash': hash, 'data': data?.map((i) => i.toJson()).toList()};
  }
}

class PriceModel {
  String? id;
  // الحقول بالعربي
  final String? titleAr;
  final String? descriptionAr;
  final String? sourceNameAr;
  // الحقول بالإنجليزي
  final String? titleEn;
  final String? descriptionEn;
  final String? sourceNameEn;

  final double? currentPrice;
  final double? oldPrice;
  final String? imageUrl;
  final String? sourceLogo;
  final String? lastUpdate;
  final String? changeStatus; // 'up', 'down', 'stable'
  final double? changePercentage;

  PriceModel({
    this.id,
    this.titleAr,
    this.descriptionAr,
    this.sourceNameAr,
    this.titleEn,
    this.descriptionEn,
    this.sourceNameEn,
    this.currentPrice,
    this.oldPrice,
    this.imageUrl,
    this.sourceLogo,
    this.lastUpdate,
    this.changeStatus,
    this.changePercentage,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      id: json['id'],
      titleAr: json['title_ar'],
      descriptionAr: json['description_ar'],
      sourceNameAr: json['source_name_ar'],
      titleEn: json['title_en'],
      descriptionEn: json['description_en'],
      sourceNameEn: json['source_name_en'],
      currentPrice: json['current_price']?.toDouble(),
      oldPrice: json['old_price']?.toDouble(),
      imageUrl: json['image_url'],
      sourceLogo: json['source_logo'],
      lastUpdate: json['last_update'],
      changeStatus: json['change_status'],
      changePercentage: json['change_percentage']?.toDouble(),
    );
  }

  // --- Helper Methods للمساعدة في الـ UI ---

  String? title(BuildContext context) {
    return context.locale.languageCode == 'ar' ? titleAr : titleEn;
  }

  String? description(BuildContext context) {
    return context.locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
  }

  String? sourceName(BuildContext context) {
    return context.locale.languageCode == 'ar' ? sourceNameAr : sourceNameEn;
  }

  // دالة لحساب الفرق بين السعرين (لو محتاج تعرضه)
  double get priceDiff => (currentPrice ?? 0) - (oldPrice ?? 0);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'description_ar': descriptionAr,
      'source_name_ar': sourceNameAr,
      'title_en': titleEn,
      'description_en': descriptionEn,
      'source_name_en': sourceNameEn,
      'current_price': currentPrice,
      'old_price': oldPrice,
      'image_url': imageUrl,
      'source_logo': sourceLogo,
      'last_update': lastUpdate,
      'change_status': changeStatus,
      'change_percentage': changePercentage,
    };
  }
}
