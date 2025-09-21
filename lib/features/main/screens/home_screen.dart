import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/core/widgets/main_drawer.dart';
import 'package:ecommerce/features/main/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/features/main/widgets/offers_carousel.dart';
import 'package:ecommerce/features/main/widgets/products_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/stores_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final homeNotifier = ref.read(featuredProductsProvider.notifier);

    return Scaffold(
      key: scaffoldState,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('الرئيسية'),
        leading: IconButton(
          onPressed: () => scaffoldState.currentState?.openDrawer(),
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(AppRoutes.searchScreenName);
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await homeNotifier.fetchInitialProducts();
        },
        child: SingleChildScrollView(
          controller: homeNotifier.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OffersCarousel(),
              SizedBox(height: 16),
              StoresSection(),
              SizedBox(height: 16),
              ProductsSection(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
