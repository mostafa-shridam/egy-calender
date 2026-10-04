import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extension/theme_extenison.dart';
import '../../../../generated/locale_keys.g.dart';

class EmptyEventWidget extends StatelessWidget {
  const EmptyEventWidget({
    super.key,
    required this.color,
  });
  final int? color;
  @override
  Widget build(BuildContext context) {
    final buildColor = Color(color ?? Theme.of(context).greySwatch.toARGB32());
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 5.4),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: buildColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.event_busy_outlined, size: 100, color: buildColor),
                Text(
                  LocaleKeys.noEvents.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: buildColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
