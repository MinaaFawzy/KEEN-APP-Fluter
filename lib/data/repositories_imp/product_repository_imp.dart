import 'package:keen_official_app/data/services/api_services.dart';
import 'package:keen_official_app/data/utils/app_apis.dart';
import 'package:keen_official_app/domain/models/product_model.dart';
import 'package:keen_official_app/domain/repositories/product_repository.dart';

class ProductRepositoryImp implements ProductRepository {
  final ApiService _apiService;

  ProductRepositoryImp(this._apiService);

  @override
  Future<List<Products>> getAllProducts() async {
    final response = await _apiService.get(
      AppApis.baseUrl,
      queryParameters: {'limit': '250'},
    );
    final List<dynamic> data =
        response.data['products']; // raw list from Shopify
    final List<Products> products =
        data
            .map(
              (productJson) =>
                  Products.fromJson(productJson as Map<String, dynamic>),
            )
            .toList();
    return products;
  }

  @override
  Future<List<Products>> getCollectionProducts(String collectionId) async {
    final response = await _apiService.get(
      AppApis.baseUrl,
      queryParameters: {'collection_id': '$collectionId', 'limit': '250'},
    );
    final List<dynamic> data =
    response.data['products']; // raw list from Shopify
    final List<Products> products =
    data
        .map(
          (productJson) =>
          Products.fromJson(productJson as Map<String, dynamic>),
    )
        .toList();
    return products;
  }


}
