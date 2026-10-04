import 'package:calender/core/extension/theme_extenison.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_style.dart';

class CustomPictures extends ConsumerWidget {
  const CustomPictures({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.first,
    required this.second,
  });
  final int index, currentIndex;
  final String first, second;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).isDark;
    return SvgPicture.asset(
      index == currentIndex ? first : second,
      height: 28,
      width: 28,
      fit: BoxFit.fill,
      colorFilter:
          index == currentIndex
              ? ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)
              : ColorFilter.mode(
                isDark ? graySwatch.shade200 : graySwatch.shade600,
                BlendMode.srcIn,
              ),
    );
  }
}
