import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/extension/theme_extenison.dart';
import '../../../../core/helper/help_functions.dart';

class RemainingTimeCircular extends StatefulWidget {
  const RemainingTimeCircular({
    super.key,
    required this.startAt,
    required this.endAt,
    required this.color,
  });
  final String startAt;
  final String endAt;
  final int color;
  @override
  State<RemainingTimeCircular> createState() => _RemainingTimeCircularState();
}

class _RemainingTimeCircularState extends State<RemainingTimeCircular> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تخزين القيم المتغيرة في متغيرات لتجنب العمليات الحسابية المتكررة داخل الـ Build
    final progressValue = getProgressValue(
      startAt: widget.startAt,
      endAt: widget.endAt,
    );
    final remainingText = formatRemainingTime(widget.endAt);
    final themeColor = Color(widget.color);

    return RepaintBoundary(
      child: SizedBox(
        width: 70,
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: progressValue,
                color: themeColor,
                backgroundColor: themeColor.withAlpha(40),
                strokeWidth: 4, // ثابتة لا تتغير
              ),
            ),
            Center(
              child: Text(
                remainingText,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
