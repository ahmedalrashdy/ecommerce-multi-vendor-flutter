import 'package:ecommerce/features/products/models/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductImageCarousel extends StatelessWidget {
  const ProductImageCarousel({
    super.key,
    required this.currentImages,
    required this.imagePageController,
  });
  final List<ProductImageModel> currentImages;
  final PageController imagePageController;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: imagePageController,
                itemCount: currentImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      currentImages[index].imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) => progress ==
                              null
                          ? child
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  );
                },
              ),
            ),
            if (currentImages.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SmoothPageIndicator(
                  controller: imagePageController,
                  count: currentImages.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Theme.of(context).primaryColor,
                    dotColor: Colors.grey.shade300,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
