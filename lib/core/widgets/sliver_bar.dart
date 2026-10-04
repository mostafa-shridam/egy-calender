import 'package:calender/features/main_page/presentation/main_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../helper/help_functions.dart';
import 'cached_image.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      expandedHeight: dataIsNotEmpty(data: imageUrl) ? size.height * 0.4 : 70,
      pinned: true,
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: CircleAvatar(
            backgroundColor: theme.scaffoldBackgroundColor.withValues(
              alpha: 0.7,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: theme.iconTheme.color,
              ),
              onPressed: () => context.go(MainPage.routeName),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            dataIsNotEmpty(data: imageUrl)
                ? CachedImage(imageUrl: imageUrl, fit: BoxFit.cover)
                : Container(color: theme.primaryColor.withValues(alpha: 0.1)),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black26,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
