import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/auth/auth_provider.dart';
import 'package:keen_official_app/data/repositories_imp/cart_repository_impl.dart';
import 'package:keen_official_app/domain/models/cart_model.dart';
import 'package:keen_official_app/domain/repositories/cart_repository.dart';

// ── Repository provider ────────────────────────────────────────────────────

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(
    ref.watch(storefrontApiServiceProvider),
    ref.watch(secureStorageProvider),
  );
});

// ── Cart State ─────────────────────────────────────────────────────────────

enum CartStatus { initial, loading, loaded, error }

class ShopifyCartState {
  final CartStatus status;
  final CartModel? cart;
  final String? errorMessage;
  final String? loadingVariantId; // tracks which variant is being added

  const ShopifyCartState({
    required this.status,
    this.cart,
    this.errorMessage,
    this.loadingVariantId,
  });

  const ShopifyCartState.initial() : this(status: CartStatus.initial);

  bool get isLoading => status == CartStatus.loading;
  bool get hasError => status == CartStatus.error;
  bool get isEmpty => cart == null || cart!.isEmpty;

  int get totalQuantity => cart?.totalQuantity ?? 0;
  double get totalAmount => cart?.cost.totalAmount ?? 0;
  String get currencyCode => cart?.cost.currencyCode ?? 'USD';

  List<CartLineItem> get lines => cart?.lines ?? [];

  ShopifyCartState copyWith({
    CartStatus? status,
    CartModel? cart,
    String? errorMessage,
    String? loadingVariantId,
  }) =>
      ShopifyCartState(
        status: status ?? this.status,
        cart: cart ?? this.cart,
        errorMessage: errorMessage,
        loadingVariantId: loadingVariantId,
      );
}

// ── Cart Notifier ──────────────────────────────────────────────────────────

class ShopifyCartNotifier extends StateNotifier<ShopifyCartState> {
  final CartRepository _repo;
  final Ref _ref;

  ShopifyCartNotifier(this._repo, this._ref)
      : super(const ShopifyCartState.initial()) {
    _loadCart();
  }

  /// Fetch or restore the existing cart on startup.
  Future<void> _loadCart() async {
    state = ShopifyCartState(status: CartStatus.loading);
    try {
      final cart = await _repo.fetchCart();
      state = ShopifyCartState(status: CartStatus.loaded, cart: cart);
    } catch (e) {
      // If no cart yet, that's fine — show empty state
      state = ShopifyCartState(status: CartStatus.loaded, cart: null);
    }
  }

  // ── Add to Cart ────────────────────────────────────────────────────────

  Future<void> addToCart(String variantId, {int quantity = 1}) async {
    state = state.copyWith(
        status: CartStatus.loading, loadingVariantId: variantId);
    try {
      final token = await _getToken();
      final cart = await _repo.addItem(
        variantId: variantId,
        quantity: quantity,
        customerAccessToken: token,
      );
      state = ShopifyCartState(status: CartStatus.loaded, cart: cart);
    } catch (e) {
      state = state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
        loadingVariantId: null,
      );
    }
  }

  // ── Remove from Cart ───────────────────────────────────────────────────

  Future<void> removeFromCart(String lineId) async {
    state = state.copyWith(status: CartStatus.loading);
    try {
      final cart = await _repo.removeItem(lineId: lineId);
      state = ShopifyCartState(status: CartStatus.loaded, cart: cart);
    } catch (e) {
      state = state.copyWith(
          status: CartStatus.error, errorMessage: e.toString());
    }
  }

  // ── Update Quantity ────────────────────────────────────────────────────

  Future<void> updateQuantity(String lineId, int quantity) async {
    state = state.copyWith(status: CartStatus.loading);
    try {
      final cart = await _repo.updateItemQuantity(
          lineId: lineId, quantity: quantity);
      state = ShopifyCartState(status: CartStatus.loaded, cart: cart);
    } catch (e) {
      state = state.copyWith(
          status: CartStatus.error, errorMessage: e.toString());
    }
  }

  // ── Refresh ────────────────────────────────────────────────────────────

  Future<void> refresh() async {
    state = state.copyWith(status: CartStatus.loading);
    try {
      final cart = await _repo.fetchCart();
      state = ShopifyCartState(status: CartStatus.loaded, cart: cart);
    } catch (e) {
      state = state.copyWith(
          status: CartStatus.error, errorMessage: e.toString());
    }
  }

  // ── Associate with logged-in customer ─────────────────────────────────

  Future<void> associateCustomer() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final cart = await _repo.associateWithCustomer(
          customerAccessToken: token);
      state = ShopifyCartState(status: CartStatus.loaded, cart: cart);
    } catch (_) {
      // Non-critical; ignore silently
    }
  }

  // ── Clear cart on logout ───────────────────────────────────────────────

  Future<void> clearCart() async {
    await _repo.clearCartId();
    state = const ShopifyCartState.initial();
  }

  // ── Checkout URL ───────────────────────────────────────────────────────

  Future<String?> getCheckoutUrl() => _repo.getCheckoutUrl();

  void clearError() {
    if (state.hasError) {
      state = state.copyWith(status: CartStatus.loaded, errorMessage: null);
    }
  }

  // ── Private ────────────────────────────────────────────────────────────

  Future<String?> _getToken() async {
    final authRepo = _ref.read(authRepositoryProvider);
    return authRepo.getStoredAccessToken();
  }
}

// ── Provider ───────────────────────────────────────────────────────────────

final shopifyCartProvider =
    StateNotifierProvider<ShopifyCartNotifier, ShopifyCartState>((ref) {
  return ShopifyCartNotifier(ref.watch(cartRepositoryProvider), ref);
});

/// Convenience: total item count badge
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(shopifyCartProvider).totalQuantity;
});

/// Convenience: check if a specific variant is in the cart
final isInCartProvider = Provider.family<bool, String>((ref, variantId) {
  final lines = ref.watch(shopifyCartProvider).lines;
  return lines.any((l) => l.variantId == variantId);
});
