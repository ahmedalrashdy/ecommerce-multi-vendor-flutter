import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ContentDisplaySettingsState extends Equatable {
  ThemeMode themeMode;

  ContentDisplaySettingsState({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
  ContentDisplaySettingsState copyWith({
    ThemeMode? themeMode,
  }) {
    return ContentDisplaySettingsState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
