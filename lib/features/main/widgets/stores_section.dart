import 'package:ecommerce/core/providers/providers.dart';
import 'package:ecommerce/features/main/widgets/featured_store_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/consts/app_routes.dart';
import '../../../core/widgets/error_viewer.dart';
import 'platform_category_choice_chip_list.dart';
import '../providers/providers.dart';
import 'section_header.dart';

class StoresSection extends ConsumerWidget {
  const StoresSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformCategoryAsync = ref.watch(platformCategoryProvider);
    final selectedCategoryId = ref.watch(selectedFeaturedStoreCategoryProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SectionHeader(
              title: "المتاجر",
              onSeeAllPressed: () {
                context.pushNamed(AppRoutes.storesListScreenName);
              },
            ),
          ),
          const SizedBox(height: 8),
          platformCategoryAsync.when(
            skipLoadingOnReload: true,
            data: (categories) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlatformCategoryChoiceChipList(
                      pCategories: categories.pCategories),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: FeaturedStoreList(
                      key: ValueKey(selectedCategoryId),
                      platformCategoryId: selectedCategoryId,
                    ),
                  ),
                ],
              );
            },
            error: (error, _) {
              return ErrorViewer(
                errorMessage: "فشل تحميل الفئات",
                height: 250,
                onRetry: () => ref.invalidate(platformCategoryProvider),
              );
            },
            loading: () {
              return const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
    );
  }
}
