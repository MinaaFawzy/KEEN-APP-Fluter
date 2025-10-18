import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/download_resize_image.dart';
import 'package:keen_official_app/app/providers/product_details/product_details_provider.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class PDImagesListWidget extends ConsumerWidget {
  const PDImagesListWidget({
    super.key,
    required this.product,
    required int currentIndex,
    required this.swipeController,
    required this.scrollController,
  }) : _currentIndex = currentIndex;

  final Products product;
  final int _currentIndex;
  final SwiperController swipeController;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 150, // Set height for the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: product.images!.length,
        itemBuilder: (context, index) {
          final bool isSelected = index == _currentIndex;
          return GestureDetector(
            onTap: () {
              swipeController.move(index);
              ref.read(currentIndexProvider.notifier).state =
                  index;
            },
            child: Container(
              width: 120,
              height: 150,
              child: Opacity(
                opacity: isSelected ? 1.0 : 0.6,
                // Dim unselected images
                child: CachedNetworkImage(
                  imageUrl: getResizedImageUrl(
                    product.images![index].src!,
                    600,
                    600,
                  ),
                  placeholder:
                      (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                  errorWidget:
                      (context, url, error) =>
                      Icon(Icons.error),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
        controller: scrollController,
      ),
    );
  }
}