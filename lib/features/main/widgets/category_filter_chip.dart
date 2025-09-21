import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

class CategoryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const CategoryFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        backgroundColor: appColors.background,
        selectedColor: appColors.primary.withOpacity(0.2),
        checkmarkColor: appColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? appColors.primary : appColors.text,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? appColors.primary : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
