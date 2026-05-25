import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/shop_methods.dart';
import 'package:keen_official_app/app/providers/home/products_provider.dart';
import 'package:keen_official_app/app/widgets/menus_widgets/side_menu_drawer.dart';
import 'package:keen_official_app/app/widgets/top_bar_widget.dart';
import 'package:keen_official_app/domain/models/product_model.dart';
import '../../widgets/card_widgets/product_card.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsTitle = ref.watch(productsTitleProvider);
    AsyncValue<List<Products>> allProductsAsync = getProductsAsyncType(
      ref,
      productsTitle,
    );
    return allProductsAsync.when(
      data: (products) {
        List<Products> allProducts = filterTopProducts(products);
        final List<ProductVariantPair> pairs = getProductVariantPairs(allProducts);
        return Scaffold(
          drawer: SideMenuDrawer(scrollController: _scrollController),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopBarWidget(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    child: Text(
                      productsTitle,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                pairs.isEmpty
                    ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        Center(child: Text('No Products Found')),
                      ],
                    )
                    : Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.51,
                              crossAxisSpacing: 0.4,
                              mainAxisSpacing: 0.5,
                            ),
                        itemCount: pairs.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: pairs[index].product,
                            variantIndex: pairs[index].variantIndex,
                          );
                        },
                        addAutomaticKeepAlives: true,
                      ),
                    ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Text('Error: $error'),
      loading:() => const Center(child: CircularProgressIndicator(color: Colors.black),),
    );
  }
}


