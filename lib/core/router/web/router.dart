import 'package:calender/features/dashboard/presentation/dashboard.dart';
import 'package:calender/features/dashboard/presentation/widgets/settings/privacy_policy.dart';
import 'package:calender/features/dashboard/presentation/widgets/settings/terms.dart';
import 'package:calender/features/login/presentation/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/dashboard/presentation/universal_ai_proccessor.dart';
import '../../../features/splash/presentation/splash.dart';
import '../../enums/constants_enums.dart';
import '../../local_services/local_storage.dart';
import '../app_routing_base.dart';
import '../dialog_router.dart';

class WebRouting extends AppRoutingBase {
  @override
  GoRouter getRoutes({List<NavigatorObserver>? observers}) {
    final bool userLoggedIn =
        LocalStorage.instance.get(Constants.loginKey.name) ?? false;
    return GoRouter(
      observers: observers,
      debugLogDiagnostics: true,
      initialLocation: SplashPage.routeName,
      routes: [
        GoRoute(
          path: SplashPage.routeName,
          name: SplashPage.routeName,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: LoginPage.routeName,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: DashboardPage.routeName,
          name: DashboardPage.routeName,
          builder: (context, state) => const DashboardPage(),
        ),
        DialogGoRoute(
          path: PrivacyPolicy.routeName,
          name: PrivacyPolicy.routeName,
          builder: (context, state) => const PrivacyPolicy(),
        ),
        DialogGoRoute(
          path: Terms.routeName,
          name: Terms.routeName,
          builder: (context, state) => const Terms(),
        ),

        DialogGoRoute(
          path: UniversalAIProcessor.routeName,
          name: UniversalAIProcessor.routeName,
          builder: (context, state) {
            final extraData = state.extra as Map<String, dynamic>;
            final type = extraData['type'] as AIType;
            final categories = extraData['categories'] as List<dynamic>?;
            final sections = extraData['sections'] as List<dynamic>?;
            return UniversalAIProcessor(
              type: type,
              categories: categories,
              sections: sections,
            );
          },
        ),
      ],

      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        final isLoggingIn = state.matchedLocation == LoginPage.routeName;

        if (user == null && !isLoggingIn && !userLoggedIn) {
          return LoginPage.routeName;
        }

        if (user != null && isLoggingIn && userLoggedIn) {
          return DashboardPage.routeName;
        }

        return null;
      },
    );
  }
}
