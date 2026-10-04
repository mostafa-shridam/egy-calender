import 'dart:convert';
import 'dart:developer';
import 'package:calender/core/router/mobile/router.dart';
import 'package:calender/features/events/presentation/event_details_page.dart';
import 'package:calender/features/main_page/presentation/main_page.dart';
import 'package:calender/features/news/presentation/news_details.dart';
import 'package:calender/features/price/presentation/price_details.dart';
import 'package:calender/features/splash/presentation/splash.dart';
import '../../features/my_events/presentation/my_event_details_page.dart';
import 'help_functions.dart';

class DeepLinkHelper {
  DeepLinkHelper._();
  static final DeepLinkHelper _instance = DeepLinkHelper._();
  static DeepLinkHelper get instance => _instance;

  Future<void> handleRouteById({required String pyload}) async {
    final router = MobileRouting.instance.router;
    log('🔔 Attempting foreground navigation for payload: $pyload');

    final convert = jsonDecode(pyload) as Map<String, dynamic>;
    final id = convert['id'] as String?;
    final type = convert['page'] as String?;

    if (id == null || type == null) {
      log('❌ Invalid payload');
      return;
    }
    log(
      '🧭 Navigating to $type with ID: $id Splash init :${AppInit.splashVisited}',
    );
    if (!AppInit.splashVisited) {
      log('ℹ️ Not on Splash, navigating to Splash first');
      AppInit.pendingNotificationPayload = pyload;
      router.go(SplashPage.routeName);
      await Future.delayed(const Duration(microseconds: 100));
    }

    Future.microtask(() async {
      switch (type) {
        case 'myEvents':
          router.pushNamed(
            MyEventDetailsPage.routeName,
            pathParameters: {'id': id},
          );
          break;

        case 'events':
          router.pushNamed(
            EventDetailsPage.routeName,
            pathParameters: {'id': id},
          );
          break;

        case 'news':
          router.pushNamed(
            NewsDetailspage.routeName,
            pathParameters: {'id': id},
          );
          break;

        case 'prices':
          router.pushNamed(
            PriceDetailsPage.routeName,
            pathParameters: {'id': id},
          );
          break;

        default:
          router.goNamed(MainPage.routeName);
          log('❌ Unsupported navigation type: $type');
      }
    });

    log('✅ Navigation executed successfully');
  }

  Future<void> launchUrl(String pyload) async {
    final convert = jsonDecode(pyload) as Map<String, dynamic>;
    final url = convert['url'] as String?;

    if (url == null) {
      log('❌ Invalid payload: URL is missing');
      return;
    } else {
      log('🔗 Launching URL: $url');
      await myLaunchURL(url);
    }
  }
}
