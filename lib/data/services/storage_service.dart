import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keen_official_app/domain/models/variants_model.dart';

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

  Future<void> saveCart(List<Variants> cart) async {
    final cartJson = cart.map((e) => e.toJson()).toList();
    final cartString = jsonEncode(cartJson); // convert to String
    await _storage.write(key: 'cart', value: cartString);

  }

  Future<List<Variants>> getCart() async {
    final cartString = await _storage.read(key: 'cart');
    if (cartString == null) return [];

    final List<dynamic> decoded = jsonDecode(cartString);
    return decoded.map((e) => Variants.fromJson(e)).toList();
  }

}
