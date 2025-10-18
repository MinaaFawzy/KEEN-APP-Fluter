import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/search_methods.dart';
import 'package:keen_official_app/app/methods/shop_methods.dart';
import 'package:keen_official_app/app/providers/search/search_providers.dart';
import 'package:keen_official_app/app/widgets/card_widgets/product_card.dart';
import 'package:keen_official_app/app/widgets/search_Widgets/search_text_field_widget.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final ScrollController _scrollController = ScrollController();
    final isSearching = ref.watch(isSearchProvider);
    final textSearch = ref.watch(textSearchValueProvider);
    final allProductsAsync = getProductsAsyncType(ref, 'All Products');
    Set<int> seen = {};

    return allProductsAsync.when(
      data: (products) {
        List<Products> filteredProducts = filterAndSortProductsForSearch(products, textSearch);
        print('${filteredProducts.length}*--*-*-*-*-*-*-**-*');
        final List<ProductCard> cards = MakeCards(filteredProducts, seen);
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SearchTextField(),
                isSearching && cards.isNotEmpty
                    ? Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.495,
                      crossAxisSpacing: 0.4,
                      mainAxisSpacing: 0.5,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return cards[index] ;
                    },
                    addAutomaticKeepAlives: true,
                  ),
                )
                    : Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                        isSearching ? Text('No Products Found') : Text('No Products Yet')
                      ],
                    ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Text('Error: $error'),
      loading:
          () => const Center(
            child: CircularProgressIndicator(color: Colors.black),
          ),
    );
  }
}





