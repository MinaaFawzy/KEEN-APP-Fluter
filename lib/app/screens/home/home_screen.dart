import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:keen_official_app/app/methods/shop_methods.dart';
import 'package:keen_official_app/app/providers/home/home_providers.dart';
import 'package:keen_official_app/app/providers/home/products_provider.dart';
import 'package:keen_official_app/app/widgets/card_widgets/product_card.dart';
import 'package:keen_official_app/app/widgets/home_widgets/banner_widget.dart';
import 'package:keen_official_app/app/widgets/home_widgets/collections_widget.dart';
import 'package:keen_official_app/app/widgets/top_bar_widget.dart';
import 'package:keen_official_app/app/widgets/menus_widgets/side_menu_drawer.dart';
import 'package:keen_official_app/data/thems/app_colors.dart';
// import 'package:keen_official_app/domain/models/product_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final banners = [
    Image.asset('assets/images/home_banner1.png'),
    Image.asset('assets/images/home_banner2.png'),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newArrivalsProductsAsync = ref.watch(filteredNewArrivalsProvider);
    final bestSellersProductsAsync = ref.watch(filteredBestSellersProvider);

    return Scaffold(
      drawer: SideMenuDrawer(scrollController: _scrollController),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TopBarWidget(),
              BannersWidget(banners: banners),
              ref
                  .watch(productsProvider)
                  .when(
                    data: (products) {
                      final filteredProducts = ref.watch(
                        collectionsProductsProvider,
                      );
                      return CollectionsWidget(products: filteredProducts);
                    },
                    error:
                        (error, stackTrace) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Error loading collections: $error'),
                        ),
                    loading:
                        () => const SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        ),
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(color: AppColors.dividerColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                        ref.read(productsTitleProvider.notifier).state =
                            'New Arrivals';
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: ref
                    .watch(newArrivalsProvider)
                    .when(
                      data: (products) {
                        final filteredProducts = newArrivalsProductsAsync;
                        if (filteredProducts.isEmpty) {
                          return Center(child: Text('No new arrivals found'));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: filteredProducts[index],
                              variantIndex: 0,
                            );
                          },
                        );
                      },
                      error:
                          (error, stackTrace) =>
                              Center(child: Text('Error: $error')),
                      loading:
                          () => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Divider(color: AppColors.dividerColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                        ref.read(productsTitleProvider.notifier).state =
                            'Best Sellers';
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: ref
                    .watch(bestSellersProvider)
                    .when(
                      data: (products) {
                        final filteredProducts = bestSellersProductsAsync;
                        if (filteredProducts.isEmpty) {
                          return Center(child: Text('No best sellers found'));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: filteredProducts[index],
                              variantIndex: 0,
                            );
                          },
                        );
                      },
                      error:
                          (error, stackTrace) =>
                              Center(child: Text('Error: $error')),
                      loading:
                          () => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
