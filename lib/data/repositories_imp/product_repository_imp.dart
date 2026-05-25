import 'package:flutter/foundation.dart';
import 'package:keen_official_app/data/services/api_services.dart';
import 'package:keen_official_app/domain/models/product_model.dart';
import 'package:keen_official_app/domain/repositories/product_repository.dart';

class ProductRepositoryImp implements ProductRepository {
  final ApiService _apiService;

  ProductRepositoryImp(this._apiService);

  @override
  Future<List<Products>> getAllProducts() async {
    final response = await _apiService.get(
      'products.json',
      queryParameters: {'limit': '250'},
    );
    final List<dynamic> data = response.data['products'];
    return compute(_parseProducts, data);
  }

  @override
  Future<List<Products>> getCollectionProducts(String collectionId) async {
    final response = await _apiService.get(
      'products.json',
      queryParameters: {'collection_id': collectionId, 'limit': '250'},
    );
    final List<dynamic> data = response.data['products'];
    return compute(_parseProducts, data);
  }
}

List<Products> _parseProducts(dynamic data) {
  final List<dynamic> list = data as List<dynamic>;
  return list
      .map((productJson) => Products.fromJson(productJson as Map<String, dynamic>))
      .toList();
}
