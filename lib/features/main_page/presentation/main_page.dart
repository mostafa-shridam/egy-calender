import 'package:calender/core/extension/theme_extenison.dart';
import 'package:calender/core/helper/help_functions.dart';
import 'package:calender/core/theme/app_colors.dart';
import 'package:calender/core/widgets/cached_image.dart';
import 'package:calender/features/login/data/providers/save_user.dart';
import 'package:calender/features/main_page/data/providers/main_provider.dart';
import 'package:calender/features/settings/presentation/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../login/data/models/user_model.dart';
import '../../my_events/presentation/add_edit_event.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});
  static const String routeName = "/main_page";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeWidgets = ref.watch(
      mainProviderProvider.select((value) => value.widgets),
    );
    final index = ref.watch(
      mainProviderProvider.select((value) => value.currentIndex),
    );

    final user = SaveUser.instance.getUser() ?? UserModel();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 300,
        leading: ListTile(
          onTap: () => context.pushNamed(SettingsPage.routeName),
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).greySwatch,
            backgroundImage:
                dataIsNotEmpty(data: user.avatar)
                    ? CachedImage(imageUrl: user.avatar ?? '').provider
                    : null,
            child:
                dataIsNotEmpty(data: user.avatar)
                    ? null
                    : const Icon(
                      Icons.person,
                      color: AppColors.primaryColor,
                      size: 28,
                    ),
          ),
          title: Text(
            getWelcomMessage(name: user.name ?? ''),
            style: context.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            getDateString(context),
            style: context.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: IndexedStack(index: index, children: homeWidgets),
      bottomNavigationBar: CustomBottomNavigationBar(index),
      floatingActionButton:
          index == 1
              ? FloatingActionButton(
                onPressed: () {
                  context.pushNamed(AddEditEventPage.routeName, extra: null);
                },
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
