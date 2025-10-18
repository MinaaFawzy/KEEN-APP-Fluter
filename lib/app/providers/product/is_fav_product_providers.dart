import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/data/services/storage_service.dart';


final totalPriceProvider = StateProvider<double>((ref) => 0);

class isFavProductNotifier extends StateNotifier<Set<String>> {
  final StorageService storageService;
  final Ref ref;

  isFavProductNotifier(this.storageService, this.ref) : super({}) {
    _loadCart();
  }
  Future<void> _loadCart() async {
    final saveFavProduct = await storageService.getFavProducts();
    state = saveFavProduct;
  }

  Future<void> addToFavProducts(String productId, WidgetRef ref) async {
    state = {...state, productId};
    print('state: $state');
    await storageService.saveFavProduct(state);
  }

  Future<void> removeFromFavProducts(String productId, WidgetRef ref) async {
    state = {...state}..remove(productId);
    print('state: $state');
    await storageService.saveFavProduct(state);
  }

  Future<void> clearCart() async {
    state = {};
    await storageService.saveFavProduct(state);
  }

}

final favProductsProvider =
StateNotifierProvider<isFavProductNotifier, Set<String>>((ref) {
  final storage = StorageService(const FlutterSecureStorage());
  return isFavProductNotifier(storage, ref);
});

