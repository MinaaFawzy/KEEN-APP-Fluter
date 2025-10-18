import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/home/home_providers.dart';
import 'package:keen_official_app/app/providers/home/products_provider.dart';

class BannersWidget extends ConsumerWidget {
  const BannersWidget({super.key, required this.banners});

  final List<Widget> banners;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Swiper(
            itemCount: banners.length,
            itemBuilder:
                (context, index) => GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: banners[index],
                  ),
                  onTap: (){
                    ref.read(bottomIndexProvider.notifier).state = 2;
                    index == 0
                        ? ref.read(productsTitleProvider.notifier).state = 'End Of Season Sale'
                        : ref.read(productsTitleProvider.notifier).state = 'Back To Uni';
                  },
                ),
            itemWidth: MediaQuery.of(context).size.width,
            itemHeight: MediaQuery.of(context).size.height * 0.6,
            layout: SwiperLayout.DEFAULT,
            onIndexChanged: (index) {},
            loop: true,
            autoplay: true,
            autoplayDelay: 5000,
            curve: Curves.fastOutSlowIn,
            duration: 1000,
          ),
    );
  }
}
