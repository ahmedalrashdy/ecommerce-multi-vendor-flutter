import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/error_viewer.dart';
import '../providers/user_address_notifier.dart';
import 'address_card.dart';

class AddressesList extends ConsumerWidget {
  const AddressesList({super.key, required this.isSelectionMode});
  final bool isSelectionMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addressNotifierProvider);

    if (state.isLoading && !state.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError && !state.hasValue) {
      return ErrorViewer(
        errorMessage: state.error.toString(),
        onRetry: () => ref.invalidate(addressNotifierProvider),
      );
    }

    final data = state.value!;

    if (data.items.isEmpty) {
      return const Center(child: Text('لم تقم بإضافة أي عناوين بعد.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.items.length,
      itemBuilder: (context, index) {
        final address = data.items[index];
        return AddressCard(address: address, isSelectionMode: isSelectionMode);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
