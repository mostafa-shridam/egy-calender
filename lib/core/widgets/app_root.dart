import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../network/network_service.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<NetworkStatus>>(networkStatusProvider, (
      previous,
      next,
    ) {
      if (previous == next) return;
      next.whenData((status) {
        switch (status) {
          case NetworkStatus.offline:
            showSnackBar(message: LocaleKeys.noInternetMessage.tr());
            break;
          case NetworkStatus.weak:
            showSnackBar(message: LocaleKeys.internetError.tr());
            break;
          case NetworkStatus.backOnline:
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            showSnackBar(message: 'Back online');
            break;
          case NetworkStatus.online:
            break;
        }
      });
    });
    return child;
  }
}
