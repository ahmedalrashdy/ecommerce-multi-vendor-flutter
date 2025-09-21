import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/features/addresses/providers/user_address_notifier.dart';
import 'package:ecommerce/features/addresses/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderShippingAddress extends ConsumerWidget {
  const OrderShippingAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAddressState = ref.watch(addressNotifierProvider).value!;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(
            color: context.colors.surface,
          ),
          child: Row(
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.location_on_outlined,
                  color: context.colors.primary,
                  size: 30,
                ),
                backgroundColor: context.colors.primary.withOpacity(.1),
              ),
              const SizedBox(width: 10),
              const Text(
                "عنوان الشحن",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        AddressCard(
            address: userAddressState.selectedUserAddress!,
            isSelectionMode: false)
      ],
    );
  }
}
