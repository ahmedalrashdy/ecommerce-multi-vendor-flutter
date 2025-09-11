import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OnboardingState extends Equatable {
  final int selectedPageIndex;
  final Color currentPageColor;
  final bool skipOnboardingOrLastPage;
  const OnboardingState(
      {required this.selectedPageIndex,
      required this.currentPageColor,
      this.skipOnboardingOrLastPage = false});

  OnboardingState copyWith(
      {int? selectedPageIndex,
      Color? currentPageColor,
      bool? skipOnboardingOrLastPage}) {
    return OnboardingState(
        selectedPageIndex: selectedPageIndex ?? this.selectedPageIndex,
        currentPageColor: currentPageColor ?? this.currentPageColor,
        skipOnboardingOrLastPage:
            skipOnboardingOrLastPage ?? this.skipOnboardingOrLastPage);
  }

  @override
  List<Object> get props =>
      [selectedPageIndex, currentPageColor, skipOnboardingOrLastPage];
}
