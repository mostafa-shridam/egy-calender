import 'package:flutter/material.dart';

import '../../../../core/extension/theme_extenison.dart';

class SlidAction extends StatelessWidget {
  const SlidAction({super.key,
    required this.onTap,
     this.radius,
    required this.color,
    required this.icon,
    required this.title,
  });
  final Function()? onTap;
  final double? radius;
  final Color? color; 
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap:onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius != null ? BorderRadiusDirectional.horizontal(
              end: Radius.circular(radius!),
            ) : null,
            color: color,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
               Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              Text(title,style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}


          