import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/home/products_provider.dart';
import 'package:keen_official_app/app/widgets/card_widgets/product_card.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

List<ProductCard> MakeCards(List<Products> allProducts, Set<int> seen) {
  List<ProductCard> cards = [];
  print("${allProducts.length}++++++--------+++++++++++");
  for (int i = 0; i < allProducts.length; i++) {
    seen.clear();
    for (var variant in allProducts[i].variants!) {
      seen.add(variant.imageId ?? 0);
    }
    for (int j = 0; j < allProducts[i].variants!.length; j++) {
      if (seen.contains(allProducts[i].variants![j].imageId)) {
        cards.add(ProductCard(product: allProducts[i], variantIndex: j));
        seen.remove(allProducts[i].variants![j].imageId);
      }
    }
  }
  print('cards count ${cards.length}');
  return cards;
}

List<Products> filterTopProducts(List<Products> products) {
  return products
      .where((product) => product.status?.toLowerCase() == "active")
      .toList();
}

AsyncValue<List<Products>> getProductsAsyncType(WidgetRef ref, String type) {
  AsyncValue<List<Products>> allProductsAsync = ref.watch(productsProvider);
  switch (type) {
    case 'All products':
      allProductsAsync = ref.watch(productsProvider);
      break;
    case 'Sets':
      allProductsAsync = ref.watch(setsProductsProvider);
      break;
    case 'Back To Uni':
      allProductsAsync = ref.watch(backToUniProductsProvider);
      break;
    case 'Dresses':
      allProductsAsync = ref.watch(dressProductsProvider);
      break;
    case 'Sale "25':
      allProductsAsync = ref.watch(onSaleProductsProvider);
      break;
    case 'All Tops':
      allProductsAsync = ref.watch(allTopsProductsProvider);
      break;
    case 'T-Shirts':
      allProductsAsync = ref.watch(tShirtProductsProvider);
      break;
    case 'Tops':
      allProductsAsync = ref.watch(topsProductsProvider);
      break;
    case 'Shirts':
      allProductsAsync = ref.watch(shirtsProductsProvider);
      break;
    case 'All Bottoms':
      allProductsAsync = ref.watch(bottomProductsProvider);
      break;
    case 'Pants':
      allProductsAsync = ref.watch(pantsProductsProvider);
      break;
    case 'Skirts':
      allProductsAsync = ref.watch(skirtsProductsProvider);
      break;
    case 'Shorts':
      allProductsAsync = ref.watch(shortsProductsProvider);
      break;
    case 'End Of Season Sale':
      allProductsAsync = ref.watch(endOfSeasonSaleProvider);
      break;
    case 'New Arrivals':
      allProductsAsync = ref.watch(newArrivalsProvider);
      break;
    case 'Best Sellers':
      allProductsAsync = ref.watch(bestSellersProvider);
      break;
    case 'Fall Layers':
      allProductsAsync = ref.watch(fallLayersProvider);
      break;
    default:
      allProductsAsync = ref.watch(productsProvider);
  }
  return allProductsAsync;
}


bool checkQuantity(Products product, int variantIndex) {

  if ((product.variants?[variantIndex].inventoryQuantity == 0) &&
      (product.variants?[variantIndex].oldInventoryQuantity == 0)) {
    for (int i = 0; i < product.variants!.length; i++) {
      if ((product.variants?[i].option2 ==
          product.variants?[variantIndex].option2) &&
          (product.variants?[i].inventoryQuantity ??  0) > 0) {
        return false;
      }
    }
    return true ;
  } else {
    return false;
  }
}