import 'package:calender/features/main_page/presentation/main_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/enums/constants_enums.dart';
import '../../../../core/local_services/local_storage.dart';

part 'generated/onboarding.g.dart';

@riverpod
class Onboarding extends _$Onboarding {
  late LocalStorage _storage;
  late final PageController controller = PageController();

  @override
  OnboardingState build() {
    _storage = LocalStorage.instance;
    return const OnboardingState(page: 0);
  }

  void nextPage(BuildContext context) async {
    if (state.page >= 2) {
      await _storage.add(Constants.onboarding.name, true);
      if (!context.mounted) return;
      context.go(MainPage.routeName);
    }

    if (controller.hasClients) {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  PageController get pageController => controller;

  void onPageChanged(int page) {
    state = state.copyWith(page: page);
  }
}

class OnboardingState {
  final int page;
  final bool isLoading;

  const OnboardingState({this.page = 0, this.isLoading = false});

  OnboardingState copyWith({int? page, bool? isLoading}) {
    return OnboardingState(
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
