import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// استبدل هذه المسارات بمسارات مشروعك الصحيحة
import '../../../core/enums/constants_enums.dart';
import '../../../core/local_services/local_storage.dart';
import '../../../core/network/network_service.dart';
import '../../../core/helper/help_functions.dart';
import '../../../core/helper/deep_link_helper.dart';
import '../../../gen/assets.gen.dart';
import '../../login/presentation/login.dart';
import '../../main_page/presentation/main_page.dart';
import '../../onboarding/presentation/onboarding.dart';
import '../data/providers/initial_data_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  static const routeName = '/splash';

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // أنميشن الـ Bouncing (التكبير والتصغير)
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // نبدأ الأنميشن بشكل متكرر (Bouncing)
    _controller.repeat(reverse: true);

    _initializeAndNavigate();
  }

  void _initializeAndNavigate() async {
    AppInit.splashVisited = true;
    final stopwatch = Stopwatch()..start();

    // 1. فحص الاتصال وحالة المستخدم
    final isOnline =
        await NetworkService.instance.checkStatus() == NetworkStatus.online;
    final bool hasFinishedOnboarding =
        LocalStorage.instance.get(Constants.onboarding.name) == true;
    final bool userLoggedIn =
        LocalStorage.instance.get(Constants.loginKey.name) ?? false;

    try {
      if (isOnline && hasFinishedOnboarding) {
        log('ℹ️ Online: Fetching initial data...');
        // يظل اللوجو يعمل Bouncing هنا أثناء الريكويست
        await ref.read(initialDataLoaderProvider.notifier).init();
      } else {
        log('ℹ️ Offline or New User: Skipping requests.');
        // ننتظر قليلاً ليظهر الـ Splash لو كان الدخول سريعاً جداً
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      log('❌ Initialization error: $e');
    } finally {
      stopwatch.stop();
      // إذا انتهى الريكويست بسرعة كبيرة، ننتظر حتى يكمل ثانيتين على الأقل لشكل جمالي
      if (stopwatch.elapsedMilliseconds < 2000) {
        await Future.delayed(
          Duration(milliseconds: 2000 - stopwatch.elapsedMilliseconds),
        );
      }

      // نوقف الأنميشن قبل الانتقال
      _controller.stop();
    }

    if (!mounted) return;

    // 2. منطق التوجيه (Navigation Logic)
    _handleNavigation(hasFinishedOnboarding, userLoggedIn);
  }

  void _handleNavigation(bool hasFinishedOnboarding, bool userLoggedIn) {
    // Web Handling
    if (kIsWeb) {
      context.go(userLoggedIn ? LoginPage.routeName : OnboardingPage.routeName);
      return;
    }

    // Notifications Handling
    if (dataIsNotEmpty(data: AppInit.pendingNotificationPayload)) {
      final payload = AppInit.pendingNotificationPayload!;
      AppInit.pendingNotificationPayload = null;
      context.goNamed(MainPage.routeName);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await DeepLinkHelper.instance.handleRouteById(pyload: payload);
      });
      return;
    }

    // Default Destination
    final destination =
        hasFinishedOnboarding ? MainPage.routeName : OnboardingPage.routeName;
    context.go(destination);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اللوجو الذي يقوم بالـ Bouncing
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Assets.images.logo.image(
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Egyptian Calendar',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppInit {
  static bool splashVisited = false;
  static String? pendingNotificationPayload;
}
