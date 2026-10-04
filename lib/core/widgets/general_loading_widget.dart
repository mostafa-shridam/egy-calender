import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/core/widgets/news_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../theme/theme_style.dart';

class GeneralLoadingWidget extends StatelessWidget {
  const GeneralLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    final color =
        isDark
            ? graySwatch.shade600.toARGB32()
            : graySwatch.shade100.toARGB32();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Skeletonizer(
            effect: ShimmerEffect(
              baseColor: isDark ? graySwatch.shade700 : graySwatch.shade200,
              highlightColor:
                  isDark
                      ? graySwatch.shade600.withAlpha(80)
                      : graySwatch.shade300.withAlpha(120),
            ),
            containersColor: Color(color),
            enableSwitchAnimation: true,
            child: NewsPriceWidget(
              color: color,
              assetImage: true,
              title: 'Egypt Finalizes Preparations',
              description:
                  'With just weeks to go, Egypt is in the final stages of preparing to host the prestigious 27th African Mens Handball Championship',
              date: '2025-12-10T11:00:00.000',
            ),
          );
        },
      ),
    );
  }
}
