import 'package:calender/core/widgets/app_loader.dart';
import 'package:calender/features/login/data/providers/auth.dart';
import 'package:calender/features/login/presentation/widgets/social_button.dart';
import 'package:calender/features/main_page/presentation/main_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../gen/assets.gen.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authProvider.select((e) => e.isLoading ?? false),
    );
    return AppLoader(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // App Logo
                Center(
                  child: SvgPicture.asset(
                    Assets.images.loginImage,
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 48),
                // Welcoming Headline
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  kIsWeb ? 'Welcome admin!, Login to continue planning events' : 'Login to continue planning your events',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),
                // Google Sign-In Button
                SocialButton(
                  width: kIsWeb ? 500 : null,
                  text: 'Continue with Google',
                  onPressed: () async {
                    await ref
                        .watch(authProvider.notifier)
                        .signInWithGoogle(context);
                  },
                  isLoading: isLoading,
                  icon: Assets.images.googleLogo,
                ),
                const SizedBox(height: 16),
                if (!kIsWeb)
                  // Guest Option (Clean & Subtle)
                  TextButton(
                    onPressed: () {
                      context.go(MainPage.routeName);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
                    child: const Text('Continue as Guest'),
                  ),
                const SizedBox(height: kIsWeb ? 200 : 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
