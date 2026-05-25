import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keen_official_app/data/services/storage_service.dart';
import 'package:keen_official_app/domain/models/variants_model.dart';

final totalPriceProvider = StateProvider<double>((ref) => 0);

class CartNotifier extends StateNotifier<List<Variants>> {
  final StorageService storageService;
  final Ref ref;

  CartNotifier(this.storageService, this.ref) : super([]) {
    _loadCart();
  }
  Future<void> _loadCart() async {
    final savedCart = await storageService.getCart();
    state = savedCart;
    _recalculateTotal();
  }


  Future<void> addToCart(Variants product, WidgetRef ref) async {
    final existingIndex = state.indexWhere((p) => p.id == product.id);
    ref.read(totalPriceProvider.notifier).state = 0 ;
    if (existingIndex != -1) {
      final updatedProduct = state[existingIndex];
      updatedProduct.cartQuantity = (updatedProduct.cartQuantity ?? 0) + 1;

      final updatedState = [...state];
      updatedState[existingIndex] = updatedProduct;
      state = updatedState;
    } else {
      product.cartQuantity = 1;
      state = [...state, product];
    }
    for (var item in state) {
      ref.read(totalPriceProvider.notifier).state +=  double.parse(item.price.toString()) * (item.cartQuantity ?? 0);
    }
    await storageService.saveCart(state);
  }

  Future<void> removeFromCart(Variants product, WidgetRef ref) async {
    final existingIndex = state.indexWhere((p) => p.id == product.id);
    ref.read(totalPriceProvider.notifier).state = 0 ;
    if (existingIndex != -1) {
      final existingProduct = state[existingIndex];

      if ((existingProduct.cartQuantity ?? 0) > 1) {
        existingProduct.cartQuantity = (existingProduct.cartQuantity ?? 1) - 1;
        final updatedState = [...state];
        updatedState[existingIndex] = existingProduct;
        state = updatedState;
      } else {
        state = state.where((p) => p.id != product.id).toList();
      }
    }
    for (var item in state) {
      ref.read(totalPriceProvider.notifier).state += double.parse(item.price.toString()) * (item.cartQuantity ?? 0);
    }
    await storageService.saveCart(state);
  }

  Future<void> clearCart() async {
    state = [];
    await storageService.saveCart(state);
  }
  void _recalculateTotal() {
    ref.read(totalPriceProvider.notifier).state = 0;
    for (var item in state) {
      ref.read(totalPriceProvider.notifier).state += double.parse(item.price.toString()) * (item.cartQuantity ?? 0);
    }
  }

}

final cartProvider =
StateNotifierProvider<CartNotifier, List<Variants>>((ref) {
  final storage = StorageService(const FlutterSecureStorage());
  return CartNotifier(storage, ref);
});