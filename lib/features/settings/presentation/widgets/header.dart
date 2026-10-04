import 'package:calender/core/extension/theme_extenison.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      color: Theme.of(context).greySwatch,
      child: Text(title, style: context.textTheme.titleMedium),
    );
  }
}
