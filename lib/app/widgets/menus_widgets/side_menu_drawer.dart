import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/shop/shop_providers.dart';
import 'package:keen_official_app/app/widgets/menus_widgets/bottoms_menu_drawer.dart';
import 'package:keen_official_app/app/widgets/menus_widgets/main_menu_drawer.dart';
import 'package:keen_official_app/app/widgets/menus_widgets/tops_menu_drawer.dart';

class SideMenuDrawer extends ConsumerWidget {
  const SideMenuDrawer({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerIndex = ref.watch(drawerIndexProvider);
    if (drawerIndex == 0) {
      return MainMenuDrawer(scrollController: scrollController);
    } else if (drawerIndex == 1) {
      return BottomsMenuDrawer(scrollController: scrollController);
    } else {
      return TopsMenuDrawer(scrollController: scrollController);
    }
  }
}
