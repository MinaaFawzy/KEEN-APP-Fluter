import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/download_resize_image.dart';
import 'package:keen_official_app/app/providers/product_details/product_details_provider.dart';
import 'package:keen_official_app/domain/models/images_model.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class ProductVariantsWidget extends ConsumerWidget {
  const ProductVariantsWidget({
    super.key,
    required this.anotherColors,
    required this.product,
    required this.swipeController,
  });

  final List<Images> anotherColors;
  final Products product;
  final SwiperController swipeController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...anotherColors
            .take(anotherColors.length)
            .map(
              (image) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: getResizedImageUrl(image.src!, 150, 150),
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(
                      width: 36,
                      height: 36,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error, size: 20),
                  ),
                ),
              onTap: () {
                for (int i = 0;i < product.images!.length;i++) {
                  if (product.images![i].src == image.src) {
                    swipeController.move(i);
                    break;
                  }
                }
                for (int i = 0;i < product.variants!.length;i++) {
                  if (product.variants![i].imageId == image.id) {
                    ref.read(variantColorIndexProvider.notifier).state = i;
                  }
                }
              },
            ),
          ),
        )
            .toList(),
      ],
    );
  }
}