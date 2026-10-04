import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/core/helper/help_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../generated/locale_keys.g.dart';

/// A stateless widget that displays date and time selection row
/// Accepts current values and callbacks - no setState
class BuildDateTimeRow extends ConsumerWidget {
  const BuildDateTimeRow({
    super.key,
    required this.label,
    required this.dateValue,
    required this.onDateTap,
  });

  final String label;
  final String dateValue;
  final VoidCallback onDateTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onDateTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          dateValue.isEmpty
              ? LocaleKeys.select_date.tr()
              : formatDateTime(dateValue, context),
          style: context.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
