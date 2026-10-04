import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/extension/theme_extenison.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
    required this.icon,
    this.width,
  });
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final String icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).greySwatch),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(icon, height: 24, width: 24),
                      const SizedBox(width: 12),
                      Text(
                        text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
