import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import '../../../core/consts/app_assets.dart';
import '../../../core/consts/simple_cache_keys.dart';
import '../models/onboarding_model.dart';
import 'on_boarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SharedPreferences _simpleCacheService = AppHelper.sharedPref;

  final pageController = PageController();

  OnboardingCubit()
      : super(OnboardingState(
            selectedPageIndex: 0, currentPageColor: _pageColors[0])) {
    pageController.addListener(() {
      if (pageController.page != null) {
        final newIndex = pageController.page!.round();
        if (newIndex != state.selectedPageIndex &&
            newIndex < _pageColors.length) {
          emit(state.copyWith(
            selectedPageIndex: newIndex,
            currentPageColor: _pageColors[newIndex],
          ));
        }
      }
    });
  }

  static final List<Color> _pageColors = [
    const Color(0xFFE3F2FD), // Light Blue - مناسبة للترحيب العام
    const Color(0xFFE8F5E9), // Soft Green - مناسبة للميزات
    const Color(0xFFFFF3E0), // Warm Orange - مناسبة للفوائد أو الخطوات التالية
    const Color(0xFFF3E5F5), // Light Purple - مناسبة للتخصيص أو الأمان
  ];

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: 'مرحباً بك في تطبيقنا!',
      description: 'اكتشف كل ما يقدمه التطبيق لمساعدتك في تحقيق أهدافك.',
      image: AppAssets.imagesOnboardingOnBoarding,
    ),
    OnboardingModel(
      title: 'ميزات قوية بين يديك', // عنوان للميزات
      description:
          'استفد من أدوات سهلة الاستخدام وإمكانيات متقدمة.', // وصف للميزات
      image: AppAssets.imagesOnboardingOnBoarding,
    ),
    OnboardingModel(
      title: 'تجربة مخصصة لك', // عنوان للتخصيص أو الفوائد
      description:
          'نحن هنا لنجعل تجربتك فريدة ومناسبة لاحتياجاتك.', // وصف للتخصيص
      image: AppAssets.imagesOnboardingOnBoarding, // صورة للتخصيص
    ),
    OnboardingModel(
      title: 'ابدأ الآن بسهولة', // عنوان للخطوة الأخيرة
      description: 'انطلق في رحلتك معنا بخطوات بسيطة وآمنة.', // وصف للبدء
      image: AppAssets.imagesOnboardingOnBoarding, // صورة للبدء أو الأمان
    ),
  ];

  bool get isLastPage => state.selectedPageIndex == onboardingPages.length - 1;

  Future<void> _setSeenOnboarding() async {
    try {
      emit(state.copyWith(skipOnboardingOrLastPage: true));
      _simpleCacheService.setBool(SimpleCacheKeys.seenOnboarding, true);
    } catch (e) {
      print(
          "OnboardingCubit: Failed to set 'seenOnboarding' flag - ${e.toString()}");
    }
  }

  Future<void> nextPage() async {
    if (isLastPage) {
      _setSeenOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> skipOnboarding() async {
    _setSeenOnboarding();
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
