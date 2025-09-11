import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import '../../../core/consts/app_routes.dart';
import '../blocs/on_boarding_cubit.dart';
import '../blocs/on_boarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: BlocConsumer<OnboardingCubit, OnboardingState>(
          listener: (ctx, state) {
            if (state.skipOnboardingOrLastPage) {
              context.go(AppRoutes.loginScreen);
            }
          },
          builder: (context, state) {
            final cubit = context.read<OnboardingCubit>();
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: state.currentPageColor,
                    child: const SizedBox.expand(),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        _buildSkipButton(context, cubit),
                        Expanded(
                          child: PageView.builder(
                            controller: cubit.pageController,
                            itemCount: cubit.onboardingPages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Hero(
                                      tag: 'onboarding_$index',
                                      child: Image.asset(
                                        cubit.onboardingPages[index].image,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.4,
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    // Title
                                    Text(
                                      cubit.onboardingPages[index].title,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    // Description
                                    Text(
                                      cubit.onboardingPages[index].description,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        // Bottom navigation
                        Container(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: List.generate(
                                  cubit.onboardingPages.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(left: 5),
                                    height: 10,
                                    width: state.selectedPageIndex == index
                                        ? 25
                                        : 10,
                                    decoration: BoxDecoration(
                                      color: state.selectedPageIndex == index
                                          ? context.colors.primary
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: cubit.nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.colors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  cubit.isLastPage ? 'ابدأ الآن' : 'التالي',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context, OnboardingCubit cubit) {
    return Align(
      alignment: Alignment.topLeft, // أو topStart لـ RTL
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextButton(
          onPressed: cubit.skipOnboarding,
          child: Text(
            'تخطي',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
