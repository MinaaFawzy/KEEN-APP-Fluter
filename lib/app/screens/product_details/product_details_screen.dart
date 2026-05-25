import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/product/is_fav_product_providers.dart';
import 'package:keen_official_app/app/providers/product_details/product_details_provider.dart';
import 'package:keen_official_app/app/widgets/card_widgets/add_to_cart_button_widget.dart';
import 'package:keen_official_app/app/widgets/card_widgets/fav_button_widget.dart';
import 'package:keen_official_app/app/widgets/product_details_widgets/pd_image_swiper_widget.dart';
import 'package:keen_official_app/app/widgets/product_details_widgets/pd_images_list_widget.dart';
import 'package:keen_official_app/app/widgets/product_details_widgets/size_list_widget.dart';
import 'package:keen_official_app/app/widgets/screen_top_bar.dart';
import 'package:keen_official_app/app/widgets/card_widgets/product_variants_widget.dart';
import 'package:keen_official_app/app/widgets/card_widgets/text_price_widget.dart';
import 'package:keen_official_app/domain/models/images_model.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class ProductDetailsScreen extends ConsumerWidget {
  ProductDetailsScreen({
    super.key,
    required this.product,
    required this.imageUrl,
    required this.variantIndex,
    required this.anotherColors,
  });

  final Products product;
  final imageUrl;
  final variantIndex;
  final List<Images> anotherColors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentIndex = ref.watch(currentIndexProvider);
    final scrollController = ref.watch(scrollControllerProvider);
    final swipeController = ref.watch(swiperControllerProvider);
    final _sizeIndex = ref.watch(sizeIndexProvider);
    final _variantColorIndex = ref.watch(variantColorIndexProvider);
    final isFavProduct = ref
        .watch(favProductsProvider)
        .contains('${product.variants?[variantIndex].id}');


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreensTopBarWidget(title: 'Product Details', space: 0.12),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Product Image
                    PDImageSwiperWidget(
                      product: product,
                      swipeController: swipeController,
                      currentIndex: _currentIndex,
                      scrollController: scrollController,
                      imageUrl: imageUrl,
                    ),
                    const SizedBox(height: 10),
                    PDImagesListWidget(
                      product: product,
                      currentIndex: _currentIndex,
                      swipeController: swipeController,
                      scrollController: scrollController,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${product.title}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('SKU: ${product.variants?[variantIndex].sku}'),
                    SizedBox(height: 8),
                    product.variants![variantIndex].inventoryQuantity! > 0
                        ? Text('Availability: In Stock')
                        : Text('Availability: Out of Stock'),
                    SizedBox(height: 8),
                    TextPriceWidget(
                      product: product.variants![variantIndex],
                      fontSize: 16,
                      detailsScreen: true,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Color: ${(_variantColorIndex >= 0 && _variantColorIndex < (product.variants?.length ?? 0)) ? (product.variants?[_variantColorIndex].option2 ?? 'No Color Found') : 'No Color Found'}',
                    ),
                    SizedBox(height: 8),
                    if (anotherColors.isNotEmpty)
                      ProductVariantsWidget(
                        anotherColors: anotherColors,
                        product: product,
                        swipeController: swipeController,
                        // variantSize: 50,
                      ),
                    SizedBox(height: 8),
                    Text(
                      'Size: ${(_sizeIndex >= 0 && _sizeIndex < (product.options![0].values?.length ?? 0)) ? (product.options![0].values?[_sizeIndex]) : 'No Size Found'}',
                    ),
                    SizedBox(height: 8),
                    SizeList(sizeIndex: _sizeIndex, product: product),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity, // Button takes full width
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: AddToCartButton(
                              title: 'Buy Now',
                              product: product,
                              variantIndex: variantIndex,
                            ),
                          ),
                          FavButtonWidget(
                            isFavProduct: isFavProduct,
                            product: product,
                            variantIndex: variantIndex,
                            radius: 14,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                    Html(
                      data: product.bodyHtml,
                      // or product['body_html'] depending on your model
                      style: {
                        "p": Style(
                          fontSize: FontSize(16),
                          lineHeight: LineHeight.em(1.4),
                        ),
                        "li": Style(fontSize: FontSize(15)),
                        "strong": Style(fontWeight: FontWeight.bold),
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getImageUrl(Products product, int index) {
  return product.images![index].src!;
}
