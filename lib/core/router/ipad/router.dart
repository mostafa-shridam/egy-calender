import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/main_page/presentation/main_page.dart';
import '../app_routing_base.dart';

class IPadRouting extends AppRoutingBase {
  @override
  GoRouter getRoutes({
    List<NavigatorObserver>? observers,
  }) {
    return GoRouter(
      //initialLocation: initialLocation,
      observers: observers,
      debugLogDiagnostics: true,
      initialLocation: MainPage.routeName,
      redirect: (context, state) {
        if (state.uri.toString().contains('dlink') == true) {
          return MainPage.routeName;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: MainPage.routeName,
          name: MainPage.routeName,
          builder: (context, state) => const MainPage(),
        ),
      ],
    );
  }
}
