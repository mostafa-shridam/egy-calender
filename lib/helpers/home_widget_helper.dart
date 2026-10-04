import 'dart:convert';
import 'dart:developer';
import 'package:home_widget/home_widget.dart';

enum WidgetDataType { news, prices, events, myEvents }

class HomeWidgetService {
  static const String _groupId = 'group.com.egy_calender';

  // 1. المفتاح (Key) لازم يكون كلمة بسيطة وموحدة في Dart و Kotlin و Swift
  static const String _dataKey = 'events';
  static const String _widgetSettings = 'widget_settings';
  static const String _androidReceiverName = 'EgyCalendarWidgetReceiver';
  static const String _iOSReceiverName = 'EgyCalendarWidget';
  static Future<void> updateWidgetList({
    required List<Map<String, dynamic>> items,
    required WidgetDataType type,
  }) async {
    // جرب تشيل السطر ده لو موجود، أو خليه بس تأكد من الاسم
    await HomeWidget.setAppGroupId(_groupId);

    final Map<String, dynamic> data = {'type': type.name, 'items': items};
    final String jsonData = jsonEncode(data);

    // بنخزن البيانات
    await HomeWidget.saveWidgetData<String>(_dataKey, jsonData);

    // أهم سطر: بننبه الأندرويد إن فيه تحديث
    await HomeWidget.updateWidget(
      name:
          _androidReceiverName, // لازم يكون مطابق لاسم الـ Receiver في المانيفست
      iOSName: _iOSReceiverName,
    );
  }

  static Future<void> updateHomeWidget({
    required String title,
    String? subtitle,
    String? imageUrl,
    String? price,
    String? eventDate,
    WidgetDataType type = WidgetDataType.news,
  }) async {
    log('updateHomeWidget');
    await HomeWidget.setAppGroupId(_groupId);

    final Map<String, dynamic> data = {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'price': price,
      'eventDate': eventDate,
      'type': type.name,
    };

    await HomeWidget.saveWidgetData<String>(_dataKey, jsonEncode(data));

    await HomeWidget.updateWidget(
      name: _androidReceiverName,
      iOSName: _iOSReceiverName,
    );
  }

  static Future<void> saveWidgetSettings(String settings) async {
    await HomeWidget.setAppGroupId(_groupId);
    await HomeWidget.saveWidgetData<String>(_widgetSettings, settings);
    await HomeWidget.updateWidget(
      name: _androidReceiverName,
      iOSName: _iOSReceiverName,
    );
  }
}
