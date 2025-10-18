import 'package:keen_official_app/app/methods/shop_methods.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

List<Products> filterAndSortProductsForSearch(List<Products> products, String query) {
  final activeProducts = filterTopProducts(products);
  final lowerQuery = query.toLowerCase().trim();

  // Split query into individual words
  final words = lowerQuery.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

  // Map each product to a score based on how many words matched
  final scoredProducts = activeProducts.map((product) {
    final title = product.title?.toLowerCase() ?? '';
    final type = product.productType?.toLowerCase() ?? '';
    final tags = product.tags?.toLowerCase() ?? '';

    int score = 0;

    for (final word in words) {
      if (title.contains(word)) score += 3; // title = higher priority
      if (type.contains(word)) score += 2;
      if (tags.contains(word)) score += 1;
    }

    return {'product': product, 'score': score};
  }).toList();

  // Filter only products with a positive score
  final filtered = scoredProducts.where((entry) => (entry['score'] as int) > 0).toList();

  // Sort by score (descending order)
  filtered.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

  // Return only the product list
  return filtered.map((entry) => entry['product'] as Products).toList();
}