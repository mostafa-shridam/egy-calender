import 'package:calender/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/extension/theme_extenison.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.onTap,
    this.data,
    this.color,
    this.switchOnChanged,
    this.switchValue,
    this.selected = false,
  });
  final String title;
  final VoidCallback? onTap;
  final String? data;
  final Color? color;
  final void Function(bool)? switchOnChanged;
  final bool? switchValue;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color?.withValues(alpha: 0.2),
      onTap: onTap,
      title: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(color: color),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      minTileHeight: 50,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (data?.isNotEmpty ?? false)
            Text(
              data ?? '',
              style: context.textTheme.bodyMedium?.copyWith(color: color),
            ),
          const SizedBox(width: 8),
          if (switchOnChanged != null)
            Switch.adaptive(
              value: switchValue ?? false,
              onChanged: switchOnChanged,
            ),
          if (switchOnChanged == null)
            Icon(
              selected ? Icons.check_circle : Icons.arrow_forward_ios,
              color: selected ? AppColors.successGreen : color,
            ),
        ],
      ),
    );
  }
}
