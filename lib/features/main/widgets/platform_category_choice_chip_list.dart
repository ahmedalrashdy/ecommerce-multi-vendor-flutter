import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/models/plateform_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class PlatformCategoryChoiceChipList extends ConsumerWidget {
  const PlatformCategoryChoiceChipList({
    super.key,
    required this.pCategories,
  });
  final List<PlatformCategory> pCategories;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedFeaturedStoreCategoryProvider);
    final notifier = ref.read(selectedFeaturedStoreCategoryProvider.notifier);

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: pCategories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: const Text("الكل"),
                selected: selectedId == null,
                selectedColor: context.colors.primary,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedId == null ? context.colors.onPrimary : null,
                ),
                onSelected: (isSelected) {
                  if (isSelected) notifier.state = null;
                },
              ),
            );
          }
          final category = pCategories[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category.name),
              selected: selectedId == category.id,
              selectedColor: context.colors.primary,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    selectedId == category.id ? context.colors.onPrimary : null,
              ),
              onSelected: (isSelected) {
                if (isSelected) notifier.state = category.id;
              },
            ),
          );
        },
      ),
    );
  }
}
