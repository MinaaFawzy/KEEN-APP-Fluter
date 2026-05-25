import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/cart/shopify_cart_provider.dart';
import 'package:keen_official_app/app/providers/product_cart/cart_providers.dart';
import 'package:keen_official_app/app/widgets/card_widgets/quick_add_bottom_sheet.dart';
import 'package:keen_official_app/data/services/toast_service.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class AddToCartButton extends ConsumerWidget {
  const AddToCartButton({
    super.key,
    required this.title,
    required this.product,
    required this.variantIndex,
    this.isProductsScreen = false,
  });

  final String title;
  final Products product;
  final int variantIndex;
  final bool isProductsScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSize = ref.watch(productSelectedSizeProvider);
    final selectedColor = ref.watch(productSelectedColorProvider);
    final isLoading =
        ref.watch(shopifyCartProvider.select((s) => s.isLoading));

    int selectedVariantIndex = 0;
    for (int i = 0; i < product.variants!.length; i++) {
      if (product.variants![i].option1!
              .toLowerCase()
              .contains(selectedSize.toLowerCase()) &&
          product.variants![i].option2?.toLowerCase() ==
              selectedColor.toLowerCase()) {
        selectedVariantIndex = i;
        for (int j = 0; j < product.images!.length; j++) {
          if (product.images![j].id ==
              product.variants![selectedVariantIndex].imageId) {
            product.variants![selectedVariantIndex].imageSrc =
                product.images![j].src;
          }
        }
        break;
      }
    }
    product.variants![selectedVariantIndex].productTitle = product.title;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: isLoading
            ? null
            : () {
                if (isProductsScreen) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => QuickAddBottomSheet(
                      product: product,
                      variantIndex: variantIndex,
                    ),
                  );
                } else {
                  // Convert Admin API integer ID to Storefront GID
                  final variantId = product
                      .variants![selectedVariantIndex].adminGraphqlApiId;
                  if (variantId != null) {
                    ref
                        .read(shopifyCartProvider.notifier)
                        .addToCart(variantId);
                    ToastManager.showSuccess(
                        context, 'Added to cart successfully!');
                  } else {
                    ToastManager.showError(
                        context, 'Unable to add to cart. Please try again.');
                  }
                  Navigator.pop(context);
                }
              },
        style: TextButton.styleFrom(
          backgroundColor: isLoading ? Colors.grey[300] : Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Text(
                title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
