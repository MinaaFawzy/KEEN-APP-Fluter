import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/download_resize_image.dart';
import 'package:keen_official_app/app/providers/product_cart/product_cart_provider.dart';
import 'package:keen_official_app/app/widgets/card_widgets/text_price_widget.dart';
import 'package:keen_official_app/data/thems/app_colors.dart';
import 'package:keen_official_app/domain/models/variants_model.dart';

class CartItemWidget extends ConsumerWidget {
  const CartItemWidget({super.key, required this.product});

  final Variants product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: getResizedImageUrl(product.imageSrc ?? '', 800, 800),
                  height: 200,
                  width:150,
                  fit: BoxFit.fill,
                  placeholder:
                      (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                ),
              ),
              SizedBox(width: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width - 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8,),
                    Text(product.productTitle ?? 'Unknown Title'),
                    SizedBox(height:8),
                    Text(product.title ?? 'Unknown Title', style: TextStyle(color: Colors.grey, fontSize: 12) ),
                    SizedBox(height: 8),
                    TextPriceWidget(product: product, fontSize: 10,isCartScreen: true),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.dividerColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed:
                                () => ref.read(cartProvider.notifier).removeFromCart(product, ref)
                          ),
                          Text('${product.cartQuantity}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed:
                                () => ref.read(cartProvider.notifier).addToCart(product, ref)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}