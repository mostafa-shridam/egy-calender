import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extension/theme_extenison.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../generated/locale_keys.g.dart';
import '../add_edit_event.dart';

class EmptyMyEventWidget extends StatelessWidget {
  const EmptyMyEventWidget({super.key, required this.color});
  final int color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 5.4),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(color).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.event_busy_outlined, size: 100, color: Color(color)),
                Text(
                  LocaleKeys.noEventsMessage.tr(),
                  style: context.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 180,
                  child: CustomButton(
                    onPressed:
                        () => context.pushNamed(AddEditEventPage.routeName),
                    text: LocaleKeys.addEvent.tr(),
                    grideantColor: Color(color),
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
