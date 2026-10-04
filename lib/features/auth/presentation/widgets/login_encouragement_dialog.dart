import 'dart:ui';
import 'package:calender/core/theme/app_colors.dart';
import 'package:calender/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../login/presentation/login.dart';

class LoginEncouragementDialog extends StatelessWidget {
  const LoginEncouragementDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const LoginEncouragementDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie Animation
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset(
                    Assets.images.logo.path, // Placeholder path
                    // Use a fallback icon if asset missing for now
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          Icons.cloud_sync_outlined,
                          size: 80,
                          color: AppColors.primaryColor,
                        ),
                  ),
                ),
                const SizedBox(height: 24),

                // Headline
                Text(
                  'Secure Your Memories',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtext
                Text(
                  'Login now to sync your data to the cloud and access it from any device. Don\'t risk losing your progress!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop(); // Close dialog
                      // Navigate to Login or Trigger Login logic
                      // Assuming Login Page is standalone, we route there?
                      // Or triggering Google Sign In directly?
                      // Prompt: "A primary 'Sign in with Google' button"
                      // Let's navigate to Login Page for full flow or simple auth trigger.
                      // Given Login UI requirement is "clean landing page...", maybe routing to it is best
                      // if we are inside the app.
                      context.go(LoginPage.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => context.pop(),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  child: const Text('Maybe Later'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
