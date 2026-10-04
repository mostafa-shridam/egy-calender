import 'dart:async';
import 'dart:developer';
import 'package:calender/core/router/index.dart';
import 'package:calender/core/theme/theme_style.dart';
import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eraser/eraser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/constants/constants.dart';
import 'core/helper/help_functions.dart';
import 'core/local_services/local_storage.dart';
import 'core/notifications/notification_initializer.dart';
import 'core/scroll_behavior.dart';
import 'core/services/life_cycle.dart';
import 'core/services/supabase.dart';
import 'core/widgets/app_root.dart';
import 'features/settings/data/providers/settings.dart';
import 'firebase_options.dart';
import 'generated/codegen_loader.g.dart';

Future<void> firstInit() async {
  try {
    await LocalStorage.instance.init();
  } catch (e) {
    log('Error while initializing local storage: $e');
  }

  try {
    await EasyLocalization.ensureInitialized();
  } catch (e) {
    log('Error while initializing easy localization: $e');
  }
  try {
    await Future.wait([
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      SupabaseService.initSupabase(),
    ]);
  } catch (e) {
    log('Cloud Services Error: $e');
  }

  if (!kIsWeb) {
    NotificationInitializer.instance.init().catchError(
      (e) => log('Notif Error: $e'),
    );
    Eraser.clearAllAppNotifications().catchError(
      (e) => log('Eraser Error: $e'),
    );
  }
}

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (kIsWeb) {
        setPathUrlStrategy();
      }
      await firstInit();
      runApp(
        EasyLocalization(
          useOnlyLangCode: true,
          useFallbackTranslations: true,
          startLocale: Locale(getLanguageCodeHelper()),
          fallbackLocale: Locale(getLanguageCodeHelper()),
          supportedLocales: supportedLocales,
          path: translationsPath,
          assetLoader: const CodegenLoader(),
          child: ProviderScope(child: CalenderApp()),
        ),
      );
    },
    (e, stack) {
      log('runZonedGuarded error $e, With Stack $stack');

      if (!kDebugMode && !kIsWeb) {
        FlutterErrorDetails(
          exception: e,
          stack: stack,
          context: ErrorDescription(
            'runZonedGuarded error $e, with stack $stack',
          ),
        );
      }
    },
  );
}

class CalenderApp extends ConsumerWidget {
  const CalenderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    HomeWidget.widgetClicked;
    final settings = ref.watch(settingsProvider);
    return GestureDetector(
      onTap: unfocusCurrent,
      child: ResponsiveBreakpoints(
        breakpoints: const [
          Breakpoint(start: 0, end: 600, name: MOBILE),
          Breakpoint(start: 601, end: 1200, name: TABLET),
          Breakpoint(start: 1201, end: double.infinity, name: DESKTOP),
        ],
        child: LifeCycleManager(
          child: AppRoot(
            child: MaterialApp.router(
              scaffoldMessengerKey: scaffoldMessengerKey,
              title: appName,
              scrollBehavior: CustomScrollBehavior(),
              debugShowCheckedModeBanner: false,
              locale: settings.language.locale,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              themeMode: settings.mode,
              theme: getLightTheme(fontFamily: settings.fontFamily.toStr),
              darkTheme: getDarkTheme(fontFamily: settings.fontFamily.toStr),
              routerConfig: Routes.instance.getRoutes(),
              builder: (context, child) {
                final mediaQueryData = MediaQuery.of(context);
                return ResponsiveScaledBox(
                  width:
                      ResponsiveValue<double?>(
                        context,
                        conditionalValues: [
                          const Condition.equals(name: MOBILE, value: 450),
                          const Condition.between(
                            start: 601,
                            end: 800,
                            value: 800,
                          ),
                          Condition.between(
                            start: 801,
                            end: 1200,
                            value: mediaQueryData.size.width,
                          ),
                          Condition.largerThan(
                            name: TABLET,
                            value: mediaQueryData.size.width,
                          ),
                        ],
                      ).value,
                  child: MediaQuery(
                    data: mediaQueryData.copyWith(
                      textScaler: TextScaler.linear(settings.fontSize.value),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: child,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
