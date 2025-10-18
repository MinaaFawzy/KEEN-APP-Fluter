import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/shop/shop_providers.dart';
import 'package:keen_official_app/app/widgets/menus_widgets/menu_item_widget.dart';
import 'package:keen_official_app/data/thems/app_colors.dart';


class TopsMenuDrawer extends ConsumerWidget {
  const TopsMenuDrawer({super.key, required this.scrollController});

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
                  'TOPS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          MenuItemWidget(
            scrollController: scrollController,
            fontSize: 12,
            title: 'Go To Tops',
            fontWeight: FontWeight.normal,
            screenTitle: "All Tops",
          ),
          MenuItemWidget(
            scrollController: scrollController,
            fontSize: 12,
            title: 'T-Shirts',
            enableRightIcon: false,
            fontWeight: FontWeight.normal,
            screenTitle: 'T-Shirts',
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'Tops',
            enableRightIcon: false,
            fontWeight: FontWeight.normal,
            screenTitle: 'Tops',
            fontSize: 12,
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'Shirts',
            enableRightIcon: false,
            fontWeight: FontWeight.normal,
            screenTitle: 'Shirts',
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}
