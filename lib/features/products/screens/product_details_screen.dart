import 'package:ecommerce/core/extensions/app_theme_extension.dart';
import 'package:ecommerce/core/widgets/result_view.dart';
import 'package:ecommerce/features/products/widgets/product_detail_app_bar.dart';
import 'package:ecommerce/features/products/widgets/product_detail_bottom_bar.dart';
import 'package:ecommerce/features/products/widgets/product_detail_header.dart';
import 'package:ecommerce/features/products/widgets/product_image_carousel.dart';
import 'package:ecommerce/features/products/widgets/product_specification_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_detail_notifier.dart';
import '../providers/product_detail_state.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;
  const ProductDetailScreen({required this.productId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailNotifierProvider(productId));
    final notifier =
        ref.read(productDetailNotifierProvider(productId).notifier);

    return ResultView(
      status: state.status,
      data: state.product,
      errorMessage: state.fetchError,
      successBuilder: (ctx, product) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  ProductDetailAppBar(product: product),
                  ProductImageCarousel(
                    currentImages: state.currentImages,
                    imagePageController: state.imagePageController,
                  ),
                  ProductDetailHeader(product: product),
                  _buildVariantSelectors(
                      context, state, notifier), // تمرير الحالة والـ notifier
                  ProductSpecificationSection(product: product),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
              if (state.selectedVariant != null)
                ProductDetailBottomBar(selectedVariant: state.selectedVariant!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVariantSelectors(BuildContext context, ProductDetailState state,
      ProductDetailNotifier notifier) {
    if (state.availableOptions.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: state.availableOptions.entries.map((entry) {
            final optionKey = entry.key;
            final optionValues = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(optionKey,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: optionValues.map((value) {
                      final isSelected =
                          state.selectedOptions[optionKey] == value;
                      final isAvailable =
                          notifier.isOptionAvailable(optionKey, value);

                      return ChoiceChip(
                        label: Text(value),
                        selected: isSelected,
                        onSelected: isAvailable
                            ? (selected) =>
                                notifier.onOptionSelected(optionKey, value)
                            : null,
                        labelStyle: TextStyle(
                          color: isAvailable
                              ? (isSelected ? Colors.white : Colors.black)
                              : Colors.grey.shade400,
                        ),
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: context.colors.primary,
                        disabledColor: Colors.grey.shade100.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: isSelected
                                  ? context.colors.primary
                                  : Colors.grey.shade300),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
