import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/models/plateform_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlatformCategoryTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PlatformCategoryTabBar(
      {super.key, required this.pCategories, required this.tabController});
  final TabController tabController;
  final List<PlatformCategory> pCategories;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, ref, child) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: List.generate(pCategories.length + 1, (index) {
              if (index == 0) {
                return const Tab(text: "الكل");
              }
              // تأكد من أن الـ index صحيح
              return Tab(text: pCategories[index - 1].name);
            }),
            unselectedLabelColor: context.colors.primary,
            labelColor: context.colors.onPrimary,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: context.colors.primary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
