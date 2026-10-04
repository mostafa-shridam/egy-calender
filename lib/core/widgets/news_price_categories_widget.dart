import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/news/data/models/news_category.dart';

class NewsPriceCategoriesWidget extends ConsumerWidget {
  const NewsPriceCategoriesWidget({
    super.key,
    this.newsCategories,
    required this.onCategoryTap,
    required this.selectedCategoryId,
  });
  final List<NewsCategoryModel>? newsCategories;
  final String selectedCategoryId;
  final Function(String id) onCategoryTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: newsCategories?.length ?? 0,
        itemBuilder: (context, index) {
          final category = newsCategories?[index];
          final isSelected = category?.id == selectedCategoryId;
          final categoryId = category?.id ?? '0';
          final color = category?.color ?? AppColors.primaryColor.toARGB32();
          return GestureDetector(
            onTap: () => onCategoryTap(categoryId),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(color)),
                borderRadius: BorderRadius.circular(8),
                color:
                    isSelected
                        ? Color(color).withValues(alpha: 0.2)
                        : Colors.transparent,
              ),
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Center(
                child: Text(
                  category?.name(context) ?? '',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Color(color) : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
