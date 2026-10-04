import 'package:easy_localization/easy_localization.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/onboarding_model.dart';

List<OnboardingModel> onboardingItems = [
  OnboardingModel(
    title: LocaleKeys.onboarding1Title.tr(),
    description: LocaleKeys.onboarding2Description.tr(),
    image: Assets.images.onboarding1.path,
    buttonTitle: LocaleKeys.next.tr(),
  ),
  OnboardingModel(
    title: LocaleKeys.onboarding2Title.tr(),
    description: LocaleKeys.onboarding2Description.tr(),
    image: Assets.images.onboarding2.path,
    buttonTitle: LocaleKeys.next.tr(),
  ),
  OnboardingModel(
    title: LocaleKeys.onboarding3Title.tr(),
    description: LocaleKeys.onboarding3Description.tr(),
    image: Assets.images.onboarding3.path,
    buttonTitle: LocaleKeys.start.tr(),
  ),
];
