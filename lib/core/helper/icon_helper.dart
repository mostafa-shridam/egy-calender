import 'package:flutter/material.dart';

class IconHelper {
  static const Map<String, IconData> _icons = {
    // مناسبات اجتماعية واحتفالات
    'birthday': Icons.cake,
    'party': Icons.celebration,
    'gift': Icons.redeem,
    'wedding': Icons.favorite,
    'dinner': Icons.restaurant,
    'coffee_date': Icons.coffee,
    'vacation': Icons.beach_access,
    'holiday': Icons.festival,

    // العمل والدراسة
    'meeting': Icons.groups,
    'work': Icons.business_center,
    'deadline': Icons.priority_high,
    'presentation': Icons.co_present,
    'school': Icons.school,
    'exam': Icons.quiz,
    'interview': Icons.assignment_ind,
    'task': Icons.task_alt,

    // صحة ورياضة
    'gym': Icons.fitness_center,
    'doctor': Icons.medical_services,
    'dentist': Icons.health_and_safety,
    'sports': Icons.sports_soccer,
    'yoga': Icons.self_improvement,
    'walking': Icons.directions_run,

    // مالية وتسوق
    'payment': Icons.payments,
    'shopping': Icons.shopping_cart,
    'subscription': Icons.autorenew,
    'bank': Icons.account_balance,

    // سفر وتنقل
    'flight': Icons.flight_takeoff,
    'travel': Icons.travel_explore,
    'car_service': Icons.directions_car,
    'hotel': Icons.hotel,

    // دينية وروحانية
    'prayer': Icons.mosque, // أو Icons.church حسب الحاجة
    'ramadan': Icons.nightlight_round,
    'family': Icons.family_restroom,

    // أيقونات عامة للأحداث
    'reminder': Icons.notifications_active,
    'location': Icons.location_on,
    'anniversary': Icons.auto_awesome,
    'other': Icons.more_horiz,
  };

  static List<IconData> getAllIcons() {
    return _icons.values.toList();
  }

  static IconData getIcon(String? iconName) {
    return _icons[iconName] ?? Icons.all_inbox;
  }

  static List<String> getAllIconNames() {
    return _icons.keys.toList();
  }

  static String getIconName(IconData iconData) {
    return _icons.entries
        .firstWhere(
          (entry) => entry.value == iconData,
          orElse: () => const MapEntry('unknown', Icons.help_outline),
        )
        .key;
  }
}
