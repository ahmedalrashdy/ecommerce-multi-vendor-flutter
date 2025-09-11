import 'package:flutter/material.dart';

class SettingsGroupHeader extends StatelessWidget {
  final String title;

  const SettingsGroupHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
