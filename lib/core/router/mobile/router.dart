import 'package:calender/features/my_events/data/models/my_event.dart';
import 'package:calender/features/my_events/presentation/add_edit_event.dart';
import 'package:calender/features/news/presentation/news_details.dart';
import 'package:calender/features/price/presentation/price_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/add_edit_category/presentation/add_edit_category.dart';
import '../../../features/events/presentation/events_page.dart';
import '../../../features/events/presentation/event_details_page.dart';
import '../../../features/login/data/models/user_model.dart';
import '../../../features/login/presentation/login.dart';
import '../../../features/main_page/presentation/main_page.dart';
import '../../../features/my_events/data/models/my_category.dart';
import '../../../features/my_events/presentation/my_event_details_page.dart';
import '../../../features/onboarding/presentation/onboarding.dart';
import '../../../features/settings/presentation/categories.dart';
import '../../../features/settings/presentation/contact_us.dart';
import '../../../features/settings/presentation/help_center.dart';
import '../../../features/settings/presentation/privacy_policy.dart';
import '../../../features/settings/presentation/profile.dart';
import '../../../features/settings/presentation/settings.dart';
import '../../../features/settings/presentation/terms.dart';
import '../../../features/splash/presentation/splash.dart';
import '../app_routing_base.dart';

class MobileRouting extends AppRoutingBase {
  // 1. Singleton Setup
  static final MobileRouting _singleton = MobileRouting._internal();
  MobileRouting._internal() {
    _router = _buildRouter();
  }
  static MobileRouting get instance => _singleton;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter _router;

  GoRouter get router => _router;

  @override
  GoRouter getRoutes({List<NavigatorObserver>? observers}) {
    return _router;
  }

  GoRouter _buildRouter() {
    return GoRouter(
      navigatorKey: navigatorKey,
      debugLogDiagnostics: true,
      initialLocation: SplashPage.routeName,

      errorBuilder: (context, state) => MainPage(),
      redirect: (context, state) {
        final isOnSplash = state.matchedLocation == SplashPage.routeName;

        if (AppInit.splashVisited == false && !isOnSplash) {
          return SplashPage.routeName;
        }
        // if (state.uri.toString().contains('dlink') == true) {
        //   return MainPage.routeName;
        // }
        return null;
      },
      routes: [
        GoRoute(
          path: SplashPage.routeName,
          name: SplashPage.routeName,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: OnboardingPage.routeName,
          name: OnboardingPage.routeName,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: LoginPage.routeName,
          name: LoginPage.routeName,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: MainPage.routeName,
          name: MainPage.routeName,
          builder: (context, state) => const MainPage(),
        ),
        GoRoute(
          path: EventsPage.routeName,
          name: EventsPage.routeName,
          builder: (context, state) => const EventsPage(),
        ),
        GoRoute(
          path: '${EventDetailsPage.routeName}/:id',
          name: EventDetailsPage.routeName,
          builder:
              (context, state) => EventDetailsPage(
                eventId: state.pathParameters['id'] as String,
              ),
        ),
        GoRoute(
          path: AddEditEventPage.routeName,
          name: AddEditEventPage.routeName,
          builder:
              (context, state) =>
                  AddEditEventPage(event: state.extra as MyEvent?),
        ),
        GoRoute(
          path: '${MyEventDetailsPage.routeName}/:id',
          name: MyEventDetailsPage.routeName,
          builder:
              (context, state) => MyEventDetailsPage(
                eventId: state.pathParameters['id'] as String,
              ),
        ),
        GoRoute(
          path: SettingsPage.routeName,
          name: SettingsPage.routeName,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: ProfilePage.routeName,
          name: ProfilePage.routeName,
          builder:
              (context, state) => ProfilePage(user: state.extra as UserModel),
        ),
        GoRoute(
          path: ContactUsPage.routeName,
          name: ContactUsPage.routeName,
          builder: (context, state) => const ContactUsPage(),
        ),
        GoRoute(
          path: HelpCenterPage.routeName,
          name: HelpCenterPage.routeName,
          builder: (context, state) => const HelpCenterPage(),
        ),
        GoRoute(
          path: PrivacyPolicyPage.routeName,
          name: PrivacyPolicyPage.routeName,
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
        GoRoute(
          path: TermsOfServicePage.routeName,
          name: TermsOfServicePage.routeName,
          builder: (context, state) => const TermsOfServicePage(),
        ),
        GoRoute(
          path: AddEditCategoryPage.routeName,
          name: AddEditCategoryPage.routeName,
          builder:
              (context, state) =>
                  AddEditCategoryPage(category: state.extra as MyCategory?),
        ),
        GoRoute(
          path: CategoriesPage.routeName,
          name: CategoriesPage.routeName,
          builder: (context, state) => const CategoriesPage(),
        ),
        GoRoute(
          path: '${NewsDetailspage.routeName}/:id',
          name: NewsDetailspage.routeName,
          builder:
              (context, state) =>
                  NewsDetailspage(newsId: state.pathParameters['id'] as String),
        ),
        GoRoute(
          path: '${PriceDetailsPage.routeName}/:id',
          name: PriceDetailsPage.routeName,
          builder:
              (context, state) => PriceDetailsPage(
                priceId: state.pathParameters['id'] as String,
              ),
        ),
      ],
    );
  }
}
