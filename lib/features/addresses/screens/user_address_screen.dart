import 'package:ecommerce/features/addresses/providers/user_address_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/consts/app_routes.dart';
import '../widgets/address_list.dart';

class UserAddressesScreen extends ConsumerWidget {
  const UserAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = GoRouterState.of(context);
    final isSelectionMode = state.extra is Map;
    final title = isSelectionMode ? "اختر عنوان الشحن" : "عناويني";
    bool floatingBtnIsActive =
        ref.watch(addressNotifierProvider).value?.selectedUserAddress != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined),
            onPressed: () {
              context.pushNamed(AppRoutes.createEditUserAddressScreenName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          child: AddressesList(isSelectionMode: isSelectionMode),
          onRefresh: () async {
            await ref.refresh(addressNotifierProvider.future);
          }),
      floatingActionButton: isSelectionMode && floatingBtnIsActive
          ? FloatingActionButton(
              onPressed: () {
                context.pushNamed(AppRoutes.orderSummaryName);
              },
              child: const Text(
                "التالي",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
