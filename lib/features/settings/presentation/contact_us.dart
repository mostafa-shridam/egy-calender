import 'package:calender/core/theme/app_colors.dart';
import 'package:calender/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/helper/help_functions.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  static const routeName = '/contact_us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.contactUs.tr())),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'We won\'t bite!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Feel free to reach out to us on any of these platforms.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _ContactCard(
              title: 'WhatsApp',
              icon: Icons.chat,
              color: const Color(0xFF25D366),
              onTap: () => myLaunchURL('https://wa.me/+201017216494'),
            ),
            const SizedBox(height: 16),
            _ContactCard(
              title: 'Facebook',
              icon: Icons.language,
              color: const Color(0xFF1877F2),
              onTap:
                  () => myLaunchURL(
                    'https://www.facebook.com/Mostafashridam.mostafa',
                  ),
            ),
            const SizedBox(height: 16),
            _ContactCard(
              title: 'GitHub',
              icon: Icons.code,
              color: AppColors.black,
              onTap: () => myLaunchURL('https://github.com/mostafa-shridam'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ContactCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
