import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/home/home_providers.dart';
import 'package:keen_official_app/app/providers/product_cart/product_cart_provider.dart';
import 'package:keen_official_app/app/providers/shop/shop_providers.dart';
import 'package:keen_official_app/data/thems/app_colors.dart';

class TopBarWidget extends ConsumerWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                ref.read(drawerIndexProvider.notifier).state = 0;
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                CupertinoIcons.list_bullet,
                size: 26,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 5),
            IconButton(
              onPressed: () {
                ref.read(bottomIndexProvider.notifier).state = 1;
              },
              icon: Icon(CupertinoIcons.search, size: 26, color: Colors.black),
            ),
            Spacer(),
            Text(
              'KEEN',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                print('Profile Button Pressed');
              },
              icon: Icon(CupertinoIcons.person, size: 26, color: Colors.black),
            ),
            SizedBox(width: 5),
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    ref.read(bottomIndexProvider.notifier).state = 4;
                  },
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    size: 26,
                    color: Colors.black,
                  ),
                ),
                cartItems.isEmpty
                    ? const SizedBox()
                    : Positioned(
                      right: 8, // adjust to move horizontally
                      top: 8, // adjust to move vertically
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            cartItems.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
