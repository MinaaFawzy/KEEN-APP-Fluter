import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/menu_drawer.dart';
import 'package:keen_official_app/app/providers/shop/shop_providers.dart';
import 'package:keen_official_app/app/widgets/menus_widgets/menu_item_widget.dart';
import 'package:keen_official_app/data/thems/app_colors.dart';

class BottomsMenuDrawer extends ConsumerWidget {
  const BottomsMenuDrawer({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: Border(right: BorderSide(color: AppColors.dividerColor)),
      child: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    ref.read(drawerIndexProvider.notifier).state = 0;
                  },
                  icon: Icon(CupertinoIcons.back),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                Text(
                  'BOTTOMS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'Go To Bottoms',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            screenTitle: 'All Bottoms',
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'Pants',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            screenTitle: 'Pants',
          ),
          MenuItemWidget(
            scrollController: scrollController,
            fontSize: 12,
            title: 'Skirts',
            fontWeight: FontWeight.normal,
            screenTitle: 'Skirts',
          ),

          MenuItemWidget(
            scrollController: scrollController,
            fontSize: 12,
            title: 'Shorts',
            fontWeight: FontWeight.normal,
            screenTitle: 'Shorts',
          ),
        ],
      ),
    );
  }
}
