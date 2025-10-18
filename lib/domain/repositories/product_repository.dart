
import 'package:keen_official_app/domain/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Products>> getAllProducts();
  Future<List<Products>> getCollectionProducts(String collectionId);

}
