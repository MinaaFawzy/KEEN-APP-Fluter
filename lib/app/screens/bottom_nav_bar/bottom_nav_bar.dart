import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/home/products_provider.dart';
import 'package:keen_official_app/app/providers/search/search_providers.dart';
import 'package:keen_official_app/app/screens/account/account_screen.dart';
import 'package:keen_official_app/app/screens/cart/cart_screen.dart';
import 'package:keen_official_app/app/screens/home/home_screen.dart';
import 'package:keen_official_app/app/screens/search/search_screen.dart';
import 'package:keen_official_app/app/screens/shop/shop_screen.dart';
import '../../providers/home/home_providers.dart';

final bottomNavHistoryProvider = StateProvider<List<int>>((ref) => [0]);

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomIndex = ref.watch(bottomIndexProvider);

    final List<Widget> screens =  [
      HomeScreen(),
      SearchScreen(),
      ShopScreen(),
      AccountScreen(),
      CartScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _handleBack(ref, context);
        }
      },
      child: Scaffold(
        body: screens[bottomIndex],
        bottomNavigationBar: BottomBar(
          selectedIndex: bottomIndex,
          items: [
            BottomBarItem(
              icon: Icon(
                CupertinoIcons.home,
                color: bottomIndex == 0 ? Colors.black : Colors.grey,
              ),
              activeColor: Colors.grey,
            ),
            BottomBarItem(
              icon: Icon(
                CupertinoIcons.search,
                color: bottomIndex == 1 ? Colors.black : Colors.grey,
              ),
              activeColor: Colors.grey,
            ),
            BottomBarItem(
              icon: Icon(
                CupertinoIcons.square_grid_2x2,
                color: bottomIndex == 2 ? Colors.black : Colors.grey,
              ),
              activeColor: Colors.grey,
            ),
            BottomBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                color: bottomIndex == 3 ? Colors.black : Colors.grey,
              ),
              activeColor: Colors.grey,
            ),
            BottomBarItem(
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: bottomIndex == 4 ? Colors.black : Colors.grey,
              ),
              activeColor: Colors.grey,
            ),
          ],
          onTap: (int value) {
            ref.read(bottomIndexProvider.notifier).state = value;
            final history = [...ref.read(bottomNavHistoryProvider)];
            history.remove(value);
            history.add(value);
            ref.read(bottomNavHistoryProvider.notifier).state = history;

            if (value == 2) {
              ref.read(productsTitleProvider.notifier).state = 'All products';
            }

            if (value != 1) {
              ref.read(isSearchProvider.notifier).state = false;
              ref.read(textSearchValueProvider.notifier).state = '';
            }
          },
        ),
      ),
    );
  }

  void _handleBack(WidgetRef ref, BuildContext context) {
    final history = [...ref.read(bottomNavHistoryProvider)];

    if (history.length > 1) {
      history.removeLast();
      final previousIndex = history.last;
      ref.read(bottomIndexProvider.notifier).state = previousIndex;
      ref.read(bottomNavHistoryProvider.notifier).state = history;
    } else {
      ref.read(bottomIndexProvider.notifier).state = 0;
      ref.read(bottomNavHistoryProvider.notifier).state = history;
    }
  }
}
