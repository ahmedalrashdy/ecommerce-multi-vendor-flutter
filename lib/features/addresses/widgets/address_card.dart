// lib/features/address/widgets/address_card.dart

import 'package:ecommerce/core/widgets/custom_confirm_diolog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/consts/app_routes.dart';
import '../../../core/models/user_address_model.dart';
import '../providers/user_address_notifier.dart';

enum AddressAction { edit, delete }

class AddressCard extends ConsumerWidget {
  final UserAddressModel address;
  final bool isSelectionMode;
  const AddressCard(
      {super.key, required this.address, required this.isSelectionMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final state = ref.watch(addressNotifierProvider);
    final isActive = isSelectionMode
        ? state.value?.selectedUserAddress?.id == address.id
        : address.isDefault;
    return Card(
      elevation: 0,
      child: Stack(
        children: [
          if (isActive)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 15,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getAddressIcon(address.label, theme.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.label,
                            style: textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (address.isDefault)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "العنوان الافتراضي",
                                style: textTheme.bodySmall
                                    ?.copyWith(color: theme.primaryColor),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelectionMode)
                      Transform.translate(
                          offset: Offset(-10, 0),
                          child: Checkbox(
                              value: isActive,
                              onChanged: (value) {
                                ref
                                    .read(addressNotifierProvider.notifier)
                                    .selectUserAddress(address);
                              })),
                    _buildPopupMenu(context, ref),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.location_city_outlined,
                  title: "المدينة",
                  content: address.city,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.signpost_outlined,
                  title: "الشارع",
                  content: address.street,
                ),
                if (address.landmark != null && address.landmark!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: _buildDetailRow(
                      icon: Icons.flag_outlined,
                      title: "أقرب معلم",
                      content: address.landmark!,
                    ),
                  ),
                const Divider(height: 24),
                if (!address.isDefault)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(addressNotifierProvider.notifier)
                            .setDefault(address.id);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          foregroundColor: theme.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text('تعيين كافتراضي'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      {required IconData icon,
      required String title,
      required String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Icon _getAddressIcon(String label, Color color) {
    IconData iconData;
    if (label.toLowerCase().contains('home') || label.contains('منزل')) {
      iconData = Icons.home_outlined;
    } else if (label.toLowerCase().contains('work') || label.contains('عمل')) {
      iconData = Icons.work_outline;
    } else {
      iconData = Icons.location_on_outlined;
    }
    return Icon(iconData, size: 32, color: color);
  }

  Widget _buildPopupMenu(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<AddressAction>(
      padding: EdgeInsets.all(0),
      icon: const Icon(Icons.more_vert),
      onSelected: (AddressAction action) {
        switch (action) {
          case AddressAction.edit:
            context.pushNamed(AppRoutes.createEditUserAddressScreenName,
                extra: address);
            break;
          case AddressAction.delete:
            showDialog(
                context: context,
                builder: (ctx) {
                  return CustomConfirmationDialog(
                      title: "حذف العنوان",
                      content: "هل أنت متأكد من حذف العنوان",
                      isDestructive: true,
                      onConfirm: () {
                        ref
                            .read(addressNotifierProvider.notifier)
                            .deleteAddress(address.id);
                      });
                });
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<AddressAction>>[
        const PopupMenuItem<AddressAction>(
          value: AddressAction.edit,
          child: ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('تعديل'),
          ),
        ),
        const PopupMenuItem<AddressAction>(
          value: AddressAction.delete,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('حذف'),
          ),
        ),
      ],
    );
  }
}
