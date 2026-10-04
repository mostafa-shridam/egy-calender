import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../extension/theme_extenison.dart';
import 'cached_image.dart';

class NewsPriceWidget extends StatelessWidget {
  final int? color;
  final String? imageUrl;
  final bool assetImage;
  final String title, description, date;
  final VoidCallback? onTap;
  const NewsPriceWidget({
    super.key,
    this.color,
    this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
    this.assetImage = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsetsDirectional.only(end: 12, start: 12),
        decoration: BoxDecoration(
          color: color != null ? Color(color!).withValues(alpha: 0.4) : null,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (dataIsNotEmpty(data: imageUrl) || assetImage) ...[
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                width: 100,
                decoration: BoxDecoration(
                  color: color != null ? Color(color!) : null,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  image: DecorationImage(
                    image:
                        dataIsNotEmpty(data: imageUrl)
                            ? CachedImage(imageUrl: imageUrl!).provider
                            : AssetImage(Assets.images.logo.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dataIsNotEmpty(data: title))
                    Text(
                      title,
                      style: context.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (dataIsNotEmpty(data: description))
                    Text(
                      description,
                      style: context.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (dataIsNotEmpty(data: date))
                    Text(
                      formatDateTime(date, context, format: dateOnlyFormat),
                      style: context.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
