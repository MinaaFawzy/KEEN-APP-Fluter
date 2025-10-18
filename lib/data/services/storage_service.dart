import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage;
  StorageService(this._storage);

  Future<void> saveFavProduct(Set<String> productId) async {
    await _storage.write(key: 'FavProductsId', value: productId.join(','));
  }

  Future<Set<String>> getFavProducts() async {
    final favProductsId = await _storage.read(key: 'FavProductsId');
    if (favProductsId == null) return {};
    return favProductsId.split(',').toSet();
  }

}
