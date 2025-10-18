import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/download_resize_image.dart';
import 'package:keen_official_app/app/providers/product_details/product_details_provider.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class PDImageSwiperWidget extends ConsumerStatefulWidget {
  const PDImageSwiperWidget({
    super.key,
    required this.product,
    required this.swipeController,
    required this.currentIndex,
    required this.scrollController,
    required this.imageUrl,
  });

  final Products product;
  final SwiperController swipeController;
  final int currentIndex;
  final ScrollController scrollController;
  final String imageUrl;

  @override
  ConsumerState<PDImageSwiperWidget> createState() => _PDImageSwiperWidgetState();
}

class _PDImageSwiperWidgetState extends ConsumerState<PDImageSwiperWidget> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < widget.product.images!.length; i++) {
        if (widget.product.images![i].src == widget.imageUrl) {
          widget.swipeController.move(i);
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    ref.read(currentIndexProvider.notifier).state = widget.currentIndex;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Swiper(
        itemCount: widget.product.images?.length ?? 0,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: getResizedImageUrl(
              widget.product.images![index].src!,
              1800,
              1800,
            ),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
          ),
        ),
        layout: SwiperLayout.DEFAULT,
        controller: widget.swipeController,
        onIndexChanged: (index) {
          if (index < widget.product.images!.length - 2 ||
              (index == widget.product.images!.length - 1 &&
                  widget.currentIndex == 0)) {
            widget.scrollController.jumpTo(index * 120);
          }
          ref.read(currentIndexProvider.notifier).state = index;
        },
        loop: true,
      ),
    );
  }
}
