import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageProvider = StateProvider<String>((ref) => '');
final currentIndexProvider = StateProvider<int>((ref) => 0);
final carouselControllerProvider = StateProvider<CarouselSliderController>((ref) => CarouselSliderController());
final scrollControllerProvider = StateProvider<ScrollController>((ref) => ScrollController());
final swiperControllerProvider = StateProvider<SwiperController>((ref) => SwiperController());

final sizeIndexProvider = StateProvider<int>((ref) => 0);
final variantColorIndexProvider = StateProvider<int>((ref) => 0);
final isFavoriteProvider = StateProvider<bool>((ref) => false);

final isFavoriteCardProvider = StateProvider<bool>((ref) => false);


