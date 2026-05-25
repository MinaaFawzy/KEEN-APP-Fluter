import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/home/products_provider.dart';

import 'package:keen_official_app/domain/models/product_model.dart';

class ProductVariantPair {
  final Products product;
  final int variantIndex;
  ProductVariantPair(this.product, this.variantIndex);
}

List<ProductVariantPair> getProductVariantPairs(List<Products> allProducts) {
  List<ProductVariantPair> pairs = [];
  Set<int> seen = {};

  allProducts.sort((a, b) {
    if (a.createdAt == null) return 1;
    if (b.createdAt == null) return -1;
    return b.createdAt!.compareTo(a.createdAt!);
  });

  for (var product in allProducts) {
    seen.clear();
    final variants = product.variants ?? [];
    for (int i = 0; i < variants.length; i++) {
      final imageId = variants[i].imageId ?? 0;
      if (!seen.contains(imageId)) {
        pairs.add(ProductVariantPair(product, i));
        seen.add(imageId);
      }
    }
  }
  return pairs;
}

List<Products> filterTopProducts(List<Products> products) {
  return products
      .where((product) => product.status?.toLowerCase() == "active")
      .toList()
    ..sort((a, b) {
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });
}

AsyncValue<List<Products>> getProductsAsyncType(WidgetRef ref, String type) {
  switch (type) {
    case 'All products':
      return ref.watch(productsProvider);
    case 'Sets':
      return ref.watch(setsProductsProvider);
    case 'Back To Uni':
      return ref.watch(backToUniProductsProvider);
    case 'Dresses':
      return ref.watch(dressProductsProvider);
    case 'Sale "25':
      return ref.watch(onSaleProductsProvider);
    case 'All Tops':
      return ref.watch(allTopsProductsProvider);
    case 'T-Shirts':
      return ref.watch(tShirtProductsProvider);
    case 'Tops':
      return ref.watch(topsProductsProvider);
    case 'Shirts':
      return ref.watch(shirtsProductsProvider);
    case 'All Bottoms':
      return ref.watch(bottomProductsProvider);
    case 'Pants':
      return ref.watch(pantsProductsProvider);
    case 'Skirts':
      return ref.watch(skirtsProductsProvider);
    case 'Shorts':
      return ref.watch(shortsProductsProvider);
    case 'End Of Season Sale':
      return ref.watch(endOfSeasonSaleProvider);
    case 'New Arrivals':
      return ref.watch(newArrivalsProvider);
    case 'Best Sellers':
      return ref.watch(bestSellersProvider);
    case 'Fall Layers':
      return ref.watch(fallLayersProvider);
    default:
      return ref.watch(productsProvider);
  }
}

bool checkQuantity(Products product, int variantIndex) {
  if ((product.variants?[variantIndex].inventoryQuantity == 0) &&
      (product.variants?[variantIndex].oldInventoryQuantity == 0)) {
    for (int i = 0; i < product.variants!.length; i++) {
      if ((product.variants?[i].option2 ==
              product.variants?[variantIndex].option2) &&
          (product.variants?[i].inventoryQuantity ?? 0) > 0) {
        return false;
      }
    }
    return true;
  } else {
    return false;
  }
}

List<List<Products>> filterProductsCollection(List<Products> products) {
  List<List<Products>> filteredProducts = [];
  List<Products> sets = [];
  List<Products> pants = [];
  List<Products> tShirts = [];

  final activeProducts = products
      .where((product) => product.status?.toLowerCase() == "active")
      .toList();

  for (var product in activeProducts) {
    final type = product.productType?.toLowerCase() ?? '';
    switch (type) {
      case 'set':
        sets.add(product);
        break;
      case 'pants':
        pants.add(product);
        break;
      case 't-shirt':
      case 'woman t-shirt':
        tShirts.add(product);
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
