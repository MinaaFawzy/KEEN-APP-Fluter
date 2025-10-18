import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/product/is_fav_product_providers.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class FavButtonWidget extends ConsumerWidget {
  const FavButtonWidget({
    super.key,
    required this.isFavProduct,
    required this.product,
    required this.radius,
    required this.size,
    required this.variantIndex,
  });

  final bool isFavProduct;
  final Products product;
  final double radius;
  final double size;
  final int variantIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        print('Favorite Button Pressed');
        if (isFavProduct) {
          ref
              .read(favProductsProvider.notifier)
              .removeFromFavProducts('${product.variants?[variantIndex].id}', ref);
        } else {
          ref
              .read(favProductsProvider.notifier)
              .addToFavProducts('${product.variants?[variantIndex].id}', ref);
        }
      },

      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: Icon(
          isFavProduct ? Icons.favorite : Icons.favorite_border,
          color: isFavProduct ? Colors.red : Colors.grey,
          size: size,
        ),
      ),
    );
  }
}