import 'package:calender/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../constants/constants.dart';

class ColorSelectionWidget extends StatelessWidget {
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorSelectionWidget({
    super.key,
    this.colors = colorsToPick,
    required this.selectedColor,
    required this.onColorSelected,
  });

  void _showCustomColorPicker(BuildContext context) {
    final isWeb = ResponsiveBreakpoints.of(context).isDesktop;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: SizedBox(
            width: isWeb && isTablet ? 650 : 400,
            height: isWeb && !isTablet ? 220 : 460,
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: onColorSelected,
              hexInputBar: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Done'),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // Add 1 to count for the "Custom" button
        itemCount: colors.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // "Custom" button
            final isCustomSelected = !colors.contains(selectedColor);
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () => _showCustomColorPicker(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withValues(alpha: 0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border:
                        isCustomSelected
                            ? Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            )
                            : null,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            );
          }

          final color = colors[index - 1];
          final isSelected = selectedColor == color;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => onColorSelected(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border:
                      isSelected
                          ? Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )
                          : null,
                ),
                child:
                    isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
