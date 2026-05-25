import 'package:keen_official_app/domain/models/cart_model.dart';

/// Abstract contract for Shopify cart operations.
abstract class CartRepository {
  /// Return the existing cart if cartId is stored, otherwise create a new one.
  Future<CartModel> getOrCreateCart({String? customerAccessToken});

  /// Add [variantId] to the cart. Creates cart if none exists.
  Future<CartModel> addItem({
    required String variantId,
    int quantity = 1,
    String? customerAccessToken,
  });

  /// Remove [lineId] from the cart.
  Future<CartModel> removeItem({required String lineId});

  /// Update the [quantity] of [lineId].
  Future<CartModel> updateItemQuantity({
    required String lineId,
    required int quantity,
  });

  /// Fetch the latest state of the cart.
  Future<CartModel?> fetchCart();

  /// Associate the cart with a logged-in customer.
  Future<CartModel> associateWithCustomer({
    required String customerAccessToken,
  });

  /// Clear the saved cart ID from secure storage.
  Future<void> clearCartId();

  /// The checkout URL of the current cart (null if no cart).
  Future<String?> getCheckoutUrl();
}
