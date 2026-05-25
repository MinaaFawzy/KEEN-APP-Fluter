import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keen_official_app/data/graphql/cart_queries.dart';
import 'package:keen_official_app/data/services/storefront_api_service.dart';
import 'package:keen_official_app/data/utils/storefront_config.dart';
import 'package:keen_official_app/domain/models/cart_model.dart';
import 'package:keen_official_app/domain/repositories/cart_repository.dart';

/// Concrete implementation of [CartRepository] using Shopify Storefront GraphQL API.
/// Supports both guest carts and customer-associated carts.
class CartRepositoryImpl implements CartRepository {
  final StorefrontApiService _api;
  final FlutterSecureStorage _storage;

  CartRepositoryImpl(this._api, this._storage);

  // ── Get or Create Cart ─────────────────────────────────────────────────────

  @override
  Future<CartModel> getOrCreateCart({String? customerAccessToken}) async {
    final savedCartId = await _storage.read(key: StorefrontConfig.kCartId);

    if (savedCartId != null) {
      // Try to fetch existing cart
      try {
        final cart = await _fetchCartById(savedCartId);
        if (cart != null) return cart;
      } catch (_) {
        // Cart may have expired; create new one
      }
    }

    return _createCart(customerAccessToken: customerAccessToken);
  }

  // ── Add Item ───────────────────────────────────────────────────────────────

  @override
  Future<CartModel> addItem({
    required String variantId,
    int quantity = 1,
    String? customerAccessToken,
  }) async {
    final cart = await getOrCreateCart(
        customerAccessToken: customerAccessToken);
    final cartId = cart.id;

    // Check if variant already in cart — if so, update quantity
    final existingLine = cart.lines
        .where((l) => l.variantId == variantId)
        .firstOrNull;

    if (existingLine != null) {
      return updateItemQuantity(
        lineId: existingLine.lineId,
        quantity: existingLine.quantity + quantity,
      );
    }

    final data = await _api.execute(
      query: CartQueries.cartLinesAdd,
      variables: {
        'cartId': cartId,
        'lines': [
          {'merchandiseId': variantId, 'quantity': quantity},
        ],
      },
    );

    return _parseCartResult(data, 'cartLinesAdd');
  }

  // ── Remove Item ────────────────────────────────────────────────────────────

  @override
  Future<CartModel> removeItem({required String lineId}) async {
    final cartId = await _getStoredCartId();

    final data = await _api.execute(
      query: CartQueries.cartLinesRemove,
      variables: {
        'cartId': cartId,
        'lineIds': [lineId],
      },
    );

    return _parseCartResult(data, 'cartLinesRemove');
  }

  // ── Update Quantity ────────────────────────────────────────────────────────

  @override
  Future<CartModel> updateItemQuantity({
    required String lineId,
    required int quantity,
  }) async {
    if (quantity <= 0) return removeItem(lineId: lineId);

    final cartId = await _getStoredCartId();

    final data = await _api.execute(
      query: CartQueries.cartLinesUpdate,
      variables: {
        'cartId': cartId,
        'lines': [
          {'id': lineId, 'quantity': quantity},
        ],
      },
    );

    return _parseCartResult(data, 'cartLinesUpdate');
  }

  // ── Fetch Cart ─────────────────────────────────────────────────────────────

  @override
  Future<CartModel?> fetchCart() async {
    final cartId = await _storage.read(key: StorefrontConfig.kCartId);
    if (cartId == null) return null;
    return _fetchCartById(cartId);
  }

  // ── Associate with Customer ────────────────────────────────────────────────

  @override
  Future<CartModel> associateWithCustomer({
    required String customerAccessToken,
  }) async {
    final cartId = await _getStoredCartId();

    final data = await _api.execute(
      query: CartQueries.cartBuyerIdentityUpdate,
      variables: {
        'cartId': cartId,
        'buyerIdentity': {'customerAccessToken': customerAccessToken},
      },
    );

    final result =
        data['cartBuyerIdentityUpdate'] as Map<String, dynamic>;
    _checkUserErrors(result);

    // Re-fetch full cart data
    final cart = await _fetchCartById(cartId);
    return cart!;
  }

  // ── Clear Cart ID ──────────────────────────────────────────────────────────

  @override
  Future<void> clearCartId() async {
    await _storage.delete(key: StorefrontConfig.kCartId);
  }

  // ── Get Checkout URL ───────────────────────────────────────────────────────

  @override
  Future<String?> getCheckoutUrl() async {
    final cart = await fetchCart();
    return cart?.checkoutUrl;
  }

  // ── Private Helpers ────────────────────────────────────────────────────────

  Future<CartModel> _createCart({String? customerAccessToken}) async {
    final input = <String, dynamic>{};
    if (customerAccessToken != null) {
      input['buyerIdentity'] = {
        'customerAccessToken': customerAccessToken,
      };
    }

    final data = await _api.execute(
      query: CartQueries.cartCreate,
      variables: {'input': input},
    );

    final cart = _parseCartResult(data, 'cartCreate');

    // Persist cart ID
    await _storage.write(key: StorefrontConfig.kCartId, value: cart.id);
    return cart;
  }

  Future<CartModel?> _fetchCartById(String cartId) async {
    final data = await _api.execute(
      query: CartQueries.getCart,
      variables: {'cartId': cartId},
    );

    final cartJson = data['cart'] as Map<String, dynamic>?;
    if (cartJson == null) return null;
    return CartModel.fromJson(cartJson);
  }

  CartModel _parseCartResult(
      Map<String, dynamic> data, String operationName) {
    final result = data[operationName] as Map<String, dynamic>;
    _checkUserErrors(result);
    final cartJson = result['cart'] as Map<String, dynamic>;
    final cart = CartModel.fromJson(cartJson);
    // Update stored cart ID in case it changed
    _storage.write(key: StorefrontConfig.kCartId, value: cart.id);
    return cart;
  }

  void _checkUserErrors(Map<String, dynamic> result) {
    final errors = (result['userErrors'] as List<dynamic>?) ?? [];
    if (errors.isNotEmpty) {
      final msg = errors
          .map((e) => (e as Map<String, dynamic>)['message'])
          .join('\n');
      throw StorefrontException(msg);
    }
  }

  Future<String> _getStoredCartId() async {
    final cartId = await _storage.read(key: StorefrontConfig.kCartId);
    if (cartId == null) {
      throw StorefrontException('No active cart. Call getOrCreateCart first.');
    }
    return cartId;
  }
}
