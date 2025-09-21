import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

class SortOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const SortOptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.colors;

    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: appColors.background,
      selectedColor: appColors.primary.withOpacity(0.2),
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
    );
  }
}
