import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:keen_official_app/domain/models/product_model.dart';
import 'package:keen_official_app/private.dart';


class GetProductsData {
  static List<Map<String, dynamic>> products = [];

  Future<List<Products>> fetchShopifyProducts() async {

    final String shopDomain = Private().SHOPIFY_DOMAIN;
    final String storefrontAccessToken = Private().SHOPIFY_TOKEN;

    print('Fetching products from Shopify.....................');
    final response = await http.get(Uri.parse(
        'https://${shopDomain}/admin/api/2023-07/products.json?product_type=T-Shirts'),
        headers: {
          'X-Shopify-Access-Token': storefrontAccessToken,
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List productsJson = data['products'];
      final List<Products> products = productsJson.map((productJson) =>
          Products.fromJson(productJson)).toList();

      return products;
    } else {
      print('Failed to fetch products: ${response.statusCode}');
      print(response.body);
      return [];
    }
  }
}

