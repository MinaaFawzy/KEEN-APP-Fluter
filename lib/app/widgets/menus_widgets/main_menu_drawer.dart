import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/widgets/menus_widgets/menu_item_widget.dart';
import 'package:keen_official_app/data/thems/app_colors.dart';

class MainMenuDrawer extends ConsumerWidget {
  const MainMenuDrawer({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: Border(right: BorderSide(color: AppColors.dividerColor)),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
              left: 16,
              top: 16,
              bottom: 0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(CupertinoIcons.multiply),
                      onPressed: () {
                        Scaffold.of(context).closeDrawer();
                      },
                    ),
                  ],
                ),
                Divider(color: AppColors.dividerColor),
              ],
            ),
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'BACK TO UNI',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            screenTitle: 'Back To Uni',
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'ON SALE',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            screenTitle: 'Sale "25',
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'FALL LAYERS',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            screenTitle: 'Fall Layers',
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'TOPS',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            screenTitle: 'Tops',
            enableRightIcon: true,
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'BOTTOMS',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            screenTitle: 'Bottoms',
            enableRightIcon: true,
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'SETS',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            screenTitle: 'Sets',
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'DRESSES',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            screenTitle: 'Dresses',
          ),
          MenuItemWidget(
            scrollController: scrollController,
            title: 'Shop All',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            screenTitle: 'All products',
          )
        ],
      ),
    );
  }
}
