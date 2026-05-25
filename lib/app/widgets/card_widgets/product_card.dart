import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/download_resize_image.dart';
import 'package:keen_official_app/app/methods/shop_methods.dart';
import 'package:keen_official_app/app/providers/product/is_fav_product_providers.dart';
import 'package:keen_official_app/app/providers/product_cart/cart_providers.dart';
import 'package:keen_official_app/app/providers/product_details/product_details_provider.dart';
import 'package:keen_official_app/app/screens/product_details/product_details_screen.dart';
import 'package:keen_official_app/app/widgets/card_widgets/add_to_cart_button_widget.dart';
import 'package:keen_official_app/app/widgets/card_widgets/card_image_widget.dart';
import 'package:keen_official_app/app/widgets/card_widgets/fav_button_widget.dart';
import 'package:keen_official_app/app/widgets/card_widgets/product_title_widget.dart';
import 'package:keen_official_app/app/widgets/card_widgets/sale_new_sold_out_widget.dart';
import 'package:keen_official_app/app/widgets/card_widgets/text_price_widget.dart';
import 'package:keen_official_app/app/widgets/card_widgets/view_button_widget.dart';
import 'package:keen_official_app/domain/models/images_model.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, required this.variantIndex});

  final int variantIndex;
  final Products product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String imageUrl = '';
    List<Images> anotherColors = [];


    final favProducts = ref.watch(favProductsProvider);

    final isFavProduct = favProducts.contains(
      '${product.variants?[variantIndex].id}',
    );
    final bool isSoldOut = checkQuantity(product, variantIndex);

    final variantImageId = product.variants?[variantIndex].imageId;
    final imagesIds = product.variants?.map((v) => v.imageId ?? 0).toSet() ?? {};

    for (var image in product.images ?? []) {
      if (image.id == variantImageId) {
        imageUrl = image.src ?? 'https://icon-library.com/images/no-image-icon/no-image-icon-0.jpg';
      }
      if (imagesIds.contains(image.id)) {
        anotherColors.add(image);
      }
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,

      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CardImageWidget(imageUrl: imageUrl),
                  SaleNewSoldOutWidget(product: product, variantIndex: variantIndex),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Column(
                      children: <Widget>[
                        FavButtonWidget(
                          isFavProduct: isFavProduct,
                          product: product,
                          variantIndex: variantIndex,
                          radius: 14,
                          size: 20,
                        ),
                        const SizedBox(height: 8),
                        ViewButtonWidget(),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProductCardTitleWidget(
                      product: product,
                      variantIndex: variantIndex,
                    ),
                    TextPriceWidget(product: product.variants![variantIndex], fontSize: 10),
                    if (anotherColors.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...anotherColors
                              .take(anotherColors.length )
                              .map(
                                (image) => Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: CircleAvatar(
                                    radius:anotherColors.length > 6 ? 9 :  12, // Size of the image circle
                                    backgroundImage:
                                        NetworkImage(
                                          getResizedImageUrl(
                                            image.src!,
                                            80,
                                            80,
                                          ),
                                        ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                  ],
                ),
              ),
              Spacer(),
              AddToCartButton(
                title:
                isSoldOut
                        ? 'NOTIFY ME'
                        : 'QUICK ADD',
                product: product,
                variantIndex: variantIndex,
                isProductsScreen: true,
              ),
            ],
          ),
          onTap: () {
            ref.read(imageProvider.notifier).state = imageUrl;
            ref.read(isFavoriteProvider.notifier).state = isFavProduct;
            ref.read(variantColorIndexProvider.notifier).state = variantIndex;
            ref.read(sizeIndexProvider.notifier).state = 0;
            ref.read(productSelectedColorProvider.notifier).state = product.variants![variantIndex].option2!;
            ref.read(productSelectedSizeProvider.notifier).state = product.variants![variantIndex].option1!;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ProductDetailsScreen(
                      product: product,
                      imageUrl: imageUrl,
                      variantIndex: variantIndex,
                      anotherColors: anotherColors,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
