import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/shop_methods.dart';
import 'package:keen_official_app/app/providers/home/home_providers.dart';
import 'package:keen_official_app/app/providers/home/products_provider.dart';
import 'package:keen_official_app/app/widgets/card_widgets/product_card.dart';
import 'package:keen_official_app/app/widgets/home_widgets/banner_widget.dart';
import 'package:keen_official_app/app/widgets/home_widgets/collections_widget.dart';
import 'package:keen_official_app/app/widgets/top_bar_widget.dart';
import 'package:keen_official_app/app/widgets/menus_widgets/side_menu_drawer.dart';
import 'package:keen_official_app/data/thems/app_colors.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final ScrollController _scrollController = ScrollController();
  final banners = [
    Image.asset('assets/images/home_banner1.png'),
    Image.asset('assets/images/home_banner2.png'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProductsAsync = getProductsAsyncType(ref, 'All products');
    final newArrivalsProductsAsync = getProductsAsyncType(ref, 'New Arrivals');
    final bestSellersProductsAsync = getProductsAsyncType(ref, 'Best Sellers');
    return allProductsAsync.when(
      data: (products) {
        final filteredProducts = filterProductsCollection(products);
        return Scaffold(
          drawer: SideMenuDrawer(scrollController: _scrollController),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TopBarWidget(),
                  BannersWidget(banners: banners),
                  CollectionsWidget(products: filteredProducts),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(color: AppColors.dividerColor,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'NEW ARRIVALS',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(bottomIndexProvider.notifier).state = 2;
                            ref.read(productsTitleProvider.notifier).state = 'New Arrivals';
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(color: Colors.black,),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (newArrivalsProductsAsync.value!.length/2).toInt(),
                        itemBuilder: (context, index) {
                          return newArrivalsProductsAsync.when(
                            data:(products){
                              List<Products> filteredProducts = filterTopProducts(products);
                              return ProductCard(product: filteredProducts[index], variantIndex: 0,);
                            },
                            error: (error, stackTrace) => Text('Error: $error'),
                            loading:
                                () =>
                            const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.black),
                            ),
                          );
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(color: AppColors.dividerColor,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BEST SELLERS',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(bottomIndexProvider.notifier).state = 2;
                            ref.read(productsTitleProvider.notifier).state = 'Best Sellers';
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(color: Colors.black,),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (newArrivalsProductsAsync.value!.length/2).toInt(),
                        itemBuilder: (context, index) {
                          return bestSellersProductsAsync.when(
                            data:(products){
                              List<Products> filteredProducts = filterTopProducts(products);
                              return ProductCard(product: filteredProducts[index], variantIndex: 0,);
                            },
                            error: (error, stackTrace) => Text('Error: $error'),
                            loading:
                                () =>
                            const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.black),
                            ),
                          );
                        }
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => Text('Error: $error'),
      loading:
          () =>
      const Center(
        child: CircularProgressIndicator(color: Colors.black),
      ),
    );
  }
}

List<List<Products>> filterProductsCollection(List<Products> products) {
  List<List<Products>> filteredProducts = [];
  List<Products> sets = [];
  List<Products> pants = [];
  List<Products> tShirts = [];
  products
      .where((product) => product.status?.toLowerCase() == "active")
      .toList();
  for (int i = 0; i < products.length; i++) {
    switch (products[i].productType!.toLowerCase()) {
      case 'set':
        sets.add(products[i]);
        break;
      case 'pants':
        pants.add(products[i]);
        break;
      case 't-shirt':
        tShirts.add(products[i]);
        break;
      case 'woman t-shirt':
        tShirts.add(products[i]);
        break;
      default:
        break;
    }
  }
  filteredProducts.add(tShirts);
  filteredProducts.add(sets);
  filteredProducts.add(pants);

  return filteredProducts;
}
