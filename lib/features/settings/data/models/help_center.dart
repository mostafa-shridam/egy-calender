import 'package:easy_localization/easy_localization.dart';

class HelpCenterModel {
  final String id;
  final String questionAr;
  final String answerAr;
  final String questionEn;
  final String answerEn;

  HelpCenterModel({
    required this.id,
    required this.questionAr,
    required this.questionEn,
    required this.answerAr,
    required this.answerEn,
  });

  factory HelpCenterModel.fromJson(Map<String, dynamic> json) {
    return HelpCenterModel(
      id: json['id']?.toString() ?? '',
      questionAr: json['question_ar'] ?? '',
      questionEn: json['question_en'] ?? '',
      answerAr: json['answer_ar'] ?? '',
      answerEn: json['answer_en'] ?? '',
    );
  }

  Map<String, dynamic> toJson({bool toLocale = false}) => {
    if (toLocale) 'id': id,
    'question_ar': questionAr,
    'question_en': questionEn,
    'answer_ar': answerAr,
    'answer_en': answerEn,
  };

  String get question =>
      Intl.getCurrentLocale() == 'ar' ? questionAr : questionEn;
  String get answer => Intl.getCurrentLocale() == 'ar' ? answerAr : answerEn;
}
