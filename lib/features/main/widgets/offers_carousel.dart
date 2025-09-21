import 'package:ecommerce/features/main/providers/providers.dart';
import 'package:ecommerce/core/widgets/offer_card.dart';
import 'package:ecommerce/features/main/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OffersCarousel extends ConsumerWidget {
  const OffersCarousel({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(offersProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SectionHeader(
                title: 'العروض والخصومات', onSeeAllPressed: () {}),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: offersAsync.when(
              data: (offers) {
                if (offers.isEmpty) {
                  return Center(
                    child: Text('لا توجد عروض حالياً'),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.length,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return OfferCard(offer: offer);
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('حدث خطأ أثناء تحميل العروض'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
