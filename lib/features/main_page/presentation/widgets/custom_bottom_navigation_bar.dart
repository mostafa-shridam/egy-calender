import 'package:calender/features/main_page/data/providers/main_provider.dart';
import 'package:calender/features/main_page/presentation/widgets/pictures.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../gen/assets.gen.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar(this.index, {super.key});
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      items: bottomNavItems(index),
      currentIndex: index,
      onTap:
          (index) => ref.read(mainProviderProvider.notifier).changeIndex(index),
    );
  }
}

List<BottomNavigationBarItem> bottomNavItems(int index) {
  return [
    BottomNavigationBarItem(
      icon: CustomPictures(
        index: index,
        currentIndex: 0,
        first: Assets.images.homeIconSelected,
        second: Assets.images.home,
      ),

      label: LocaleKeys.events.tr(),
    ),
    BottomNavigationBarItem(
      icon: CustomPictures(
        index: index,
        currentIndex: 1,
        first: Assets.images.myEventsIconSelected,
        second: Assets.images.myEventsIcon,
      ),
      label: LocaleKeys.myEvents.tr(),
    ),
    BottomNavigationBarItem(
      icon: CustomPictures(
        index: index,
        currentIndex: 2,
        first: Assets.images.newsIconSelected,
        second: Assets.images.newsIcon,
      ),
      label: LocaleKeys.news.tr(),
    ),
    BottomNavigationBarItem(
      icon: CustomPictures(
        index: index,
        currentIndex: 3,
        first: Assets.images.receipt,
        second: Assets.images.receiptOutline,
      ),

      label: LocaleKeys.prices.tr(),
    ),
  ];
}
