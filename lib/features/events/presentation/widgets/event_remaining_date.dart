import 'package:flutter/material.dart';

import '../../../../core/extension/theme_extenison.dart';
import '../../../../core/helper/help_functions.dart';

class EventRemainingDate extends StatelessWidget {
  const EventRemainingDate({
    super.key,
    required this.date,
    required this.createdAt,
    required this.color,
  });
  final String date;
  final String createdAt;
  final int color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Color(color).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          formatRemainingTime(date),
          style: context.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
