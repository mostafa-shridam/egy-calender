import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.withDeafultTextColor = false,
    this.grideantColor,
    this.width = double.infinity,
    this.height = 50,
  });
  final double width, height;
  final Color? grideantColor;
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color, textColor;
  final bool withDeafultTextColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        width: width,
        height: height,
        decoration:
            isLoading
                ? BoxDecoration(
                  color:
                  grideantColor?.withAlpha(120) ??
                      color?.withAlpha(120) ??
                      AppColors.primaryColor.withAlpha(120),
                  borderRadius: BorderRadius.circular(12),
                )
                : BoxDecoration(
                  gradient:
                      color != null
                          ? null
                          : LinearGradient(
                            colors:
                                grideantColor != null
                                    ? [
                                      grideantColor!,
                                      grideantColor!.withValues(alpha: 0.2),
                                    ]
                                    : [
                                      AppColors.primaryColor,
                                      AppColors.primaryColor.withValues(
                                        alpha: 0.3,
                                      ),
                                    ],
                          ),
                  color: grideantColor ?? color,

                  borderRadius: BorderRadius.circular(12),
                ),
        child: Center(
          child:
              isLoading
                  ? CircularProgressIndicator(color: grideantColor ?? color)
                  : Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          withDeafultTextColor
                              ? null
                              : textColor ?? Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }
}
