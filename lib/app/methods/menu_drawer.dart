import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/home/home_providers.dart';
import 'package:keen_official_app/app/providers/home/products_provider.dart';
import 'package:keen_official_app/app/providers/shop/shop_providers.dart';

class MenuDrawer {
  void navigateFromDrawer(BuildContext context, Widget page) async {
    await Future.delayed(Duration(milliseconds: 200));
    Navigator.of(context).pop();

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    });
  }

  void scrollToTop(ScrollController _scrollController) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}

void pressMenuTitle({
  required String title,
  required ScrollController scrollController,
  required WidgetRef ref,
  required BuildContext context,
}) {
  if (ref.read(drawerIndexProvider) == 0) {
    if (title == 'Bottoms') {
      ref.read(drawerIndexProvider.notifier).state = 1;
      return;
    } else if (title == 'Tops') {
      ref.read(drawerIndexProvider.notifier).state = 2;
      return;
    } else {
      Scaffold.of(context).closeDrawer();
      MenuDrawer().scrollToTop(scrollController);
      ref.read(bottomIndexProvider.notifier).state = 2;
      ref.read(productsTitleProvider.notifier).state = title;
    }
  } else {
    Scaffold.of(context).closeDrawer();
    MenuDrawer().scrollToTop(scrollController);
    ref.read(bottomIndexProvider.notifier).state = 2;
    ref.read(productsTitleProvider.notifier).state = title;
  }
}
