import 'package:ecommerce/core/widgets/simple_app_bar.dart';
import 'package:ecommerce/features/products/providers/products_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce/features/main/models/offer_model.dart';
import 'package:ecommerce/features/main/providers/providers.dart';

class OfferDetailsScreen extends ConsumerWidget {
  final String offerId;

  const OfferDetailsScreen({Key? key, required this.offerId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(offersProvider);

    return Scaffold(
      appBar: SimpleAppBar(
        title: "تفاصيل العرض",
      ),
      body: offersAsync.when(
        data: (offers) {
          final offer = offers.firstWhere(
            (offer) => offer.id == offerId,
            orElse: () => OfferModel(
              id: '',
              title: 'غير متوفر',
              description: 'العرض غير متوفر',
              imageUrl: '',
              discountPercentage: 0,
              productId: '',
              storeId: '',
              validUntil: DateTime.now(),
              couponCode: '',
            ),
          );

          if (offer.id.isEmpty) {
            return const Center(child: Text('العرض غير متوفر'));
          }

          // استرجاع معلومات المنتج المرتبط بالعرض إذا كان متاحاً
          final productsAsync = ref.watch(paginatedProductsProvider(null));

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // صورة العرض
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    offer.imageUrl.isNotEmpty
                        ? offer.imageUrl
                        : 'https://via.placeholder.com/400x200?text=عرض+خاص',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.error_outline, size: 40),
                        ),
                      );
                    },
                  ),
                ),

                // تفاصيل العرض
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              offer.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${offer.discountPercentage}% خصم',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        offer.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      if (offer.couponCode.isNotEmpty) ...[
                        const Text(
                          'كود الخصم:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                offer.couponCode,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  // نسخ كود الكوبون
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم نسخ كود الخصم'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        'صالح حتى: ${offer.validUntil.day}/${offer.validUntil.month}/${offer.validUntil.year}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // عرض معلومات المنتج المرتبط بالعرض
                      if (offer.productId?.isNotEmpty == true)
                        productsAsync.when(
                          data: (paginatedProducts) {
                            final product = paginatedProducts.items.firstWhere(
                              (p) => p.id == offer.productId,
                            );

                            if (product.id == -1) {
                              return const SizedBox.shrink();
                            }

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'المنتج المرتبط بالعرض',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: product.imageUrl.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                product.imageUrl,
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            ),
                                      title: Text(product.name),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            '${product.finalPrice} ريال',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          if (product.discountPercentage > 0)
                                            Text(
                                              '${product.price} ريال',
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          // التنقل إلى صفحة تفاصيل المنتج
                                        },
                                        child: const Text('عرض'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) =>
                              const Text('حدث خطأ في تحميل بيانات المنتج'),
                        ),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            // استخدام العرض أو الانتقال إلى المتجر
                          },
                          child: const Text(
                            'استخدام العرض',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('حدث خطأ في تحميل بيانات العرض')),
      ),
    );
  }
}
