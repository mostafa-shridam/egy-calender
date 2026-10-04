import 'package:calender/core/mixins/alert_mixin.dart';
import 'package:calender/features/login/data/models/user_model.dart';
import 'package:calender/features/login/presentation/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extension/theme_extenison.dart';
import '../../../../core/helper/help_functions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cached_image.dart';
import '../profile.dart';

class ProfileWidget extends StatelessWidget with AlertMixin {
  const ProfileWidget({super.key, this.user});
  final UserModel? user;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (user == null) {
          showWarningAlert(
            context: context,
            title: 'Login',
            message: 'You are not logged in',
            confirmText: 'Login',
            onConfirm: () {
              context.pushNamed(LoginPage.routeName);
            },
          );
        } else {
          context.pushNamed(ProfilePage.routeName, extra: user);
        }
      },
      contentPadding: const EdgeInsets.all(16),

      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).greySwatch,
        backgroundImage:
            dataIsNotEmpty(data: user?.avatar)
                ? CachedImage(imageUrl: user?.avatar ?? '').provider
                : null,
        child:
            dataIsNotEmpty(data: user?.avatar)
                ? null
                : const Icon(
                  Icons.person,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
      ),
      title: Text(
        user?.name ?? '',
        style: context.textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        user?.email ?? '',
        style: context.textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
