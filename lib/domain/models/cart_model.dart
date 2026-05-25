/// Represents a single cart line item from Shopify Storefront API.
class CartLineItem {
  final String lineId;        // cart line ID (used for update/remove)
  final String variantId;     // merchandise variant GID
  final String productId;
  final String productTitle;
  final String variantTitle;
  final String handle;
  final String vendor;
  final String? imageUrl;
  final String? imageAlt;
  final double price;          // price per unit
  final double? compareAtPrice;
  final String currencyCode;
  final int quantity;
  final double totalLinePrice;
  final bool availableForSale;
  final List<SelectedOption> selectedOptions;

  const CartLineItem({
    required this.lineId,
    required this.variantId,
    required this.productId,
    required this.productTitle,
    required this.variantTitle,
    required this.handle,
    required this.vendor,
    this.imageUrl,
    this.imageAlt,
    required this.price,
    this.compareAtPrice,
    required this.currencyCode,
    required this.quantity,
    required this.totalLinePrice,
    required this.availableForSale,
    this.selectedOptions = const [],
  });

  factory CartLineItem.fromJson(Map<String, dynamic> json) {
    final merchandise = json['merchandise'] as Map<String, dynamic>;
    final product = merchandise['product'] as Map<String, dynamic>;
    final image = merchandise['image'] as Map<String, dynamic>?;
    final priceNode = merchandise['price'] as Map<String, dynamic>;
    final compareAtPriceNode =
        merchandise['compareAtPrice'] as Map<String, dynamic>?;
    final costNode = json['cost'] as Map<String, dynamic>;
    final totalNode = costNode['totalAmount'] as Map<String, dynamic>;
    final selectedOpts =
        (merchandise['selectedOptions'] as List<dynamic>? ?? [])
            .map((o) => SelectedOption.fromJson(o as Map<String, dynamic>))
            .toList();

    return CartLineItem(
      lineId: json['id'] as String,
      variantId: merchandise['id'] as String,
      productId: product['id'] as String,
      productTitle: product['title'] as String,
      variantTitle: merchandise['title'] as String,
      handle: product['handle'] as String,
      vendor: product['vendor'] as String,
      imageUrl: image?['url'] as String?,
      imageAlt: image?['altText'] as String?,
      price: double.parse(priceNode['amount'] as String),
      compareAtPrice: compareAtPriceNode != null
          ? double.tryParse(compareAtPriceNode['amount'] as String)
          : null,
      currencyCode: priceNode['currencyCode'] as String,
      quantity: json['quantity'] as int,
      totalLinePrice: double.parse(totalNode['amount'] as String),
      availableForSale: merchandise['availableForSale'] as bool? ?? true,
      selectedOptions: selectedOpts,
    );
  }

  CartLineItem copyWith({int? quantity}) => CartLineItem(
        lineId: lineId,
        variantId: variantId,
        productId: productId,
        productTitle: productTitle,
        variantTitle: variantTitle,
        handle: handle,
        vendor: vendor,
        imageUrl: imageUrl,
        imageAlt: imageAlt,
        price: price,
        compareAtPrice: compareAtPrice,
        currencyCode: currencyCode,
        quantity: quantity ?? this.quantity,
        totalLinePrice: price * (quantity ?? this.quantity),
        availableForSale: availableForSale,
        selectedOptions: selectedOptions,
      );
}

class SelectedOption {
  final String name;
  final String value;

  const SelectedOption({required this.name, required this.value});

  factory SelectedOption.fromJson(Map<String, dynamic> json) =>
      SelectedOption(name: json['name'] as String, value: json['value'] as String);
}

/// Represents the cost breakdown of a cart.
class CartCost {
  final double totalAmount;
  final double subtotalAmount;
  final double? taxAmount;
  final String currencyCode;

  const CartCost({
    required this.totalAmount,
    required this.subtotalAmount,
    this.taxAmount,
    required this.currencyCode,
  });

  factory CartCost.fromJson(Map<String, dynamic> json) {
    final total = json['totalAmount'] as Map<String, dynamic>;
    final subtotal = json['subtotalAmount'] as Map<String, dynamic>;
    final tax = json['totalTaxAmount'] as Map<String, dynamic>?;
    return CartCost(
      totalAmount: double.parse(total['amount'] as String),
      subtotalAmount: double.parse(subtotal['amount'] as String),
      taxAmount: tax != null ? double.tryParse(tax['amount'] as String) : null,
      currencyCode: total['currencyCode'] as String,
    );
  }
}

/// Top-level cart model returned by Shopify Storefront API.
class CartModel {
  final String id;            // Shopify cart GID  (gid://shopify/Cart/...)
  final String checkoutUrl;
  final int totalQuantity;
  final CartCost cost;
  final List<CartLineItem> lines;

  const CartModel({
    required this.id,
    required this.checkoutUrl,
    required this.totalQuantity,
    required this.cost,
    required this.lines,
  });

  bool get isEmpty => lines.isEmpty;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final lineEdges = json['lines']['edges'] as List<dynamic>;
    final lines = lineEdges
        .map((e) => CartLineItem.fromJson(e['node'] as Map<String, dynamic>))
        .toList();

    return CartModel(
      id: json['id'] as String,
      checkoutUrl: json['checkoutUrl'] as String,
      totalQuantity: json['totalQuantity'] as int,
      cost: CartCost.fromJson(json['cost'] as Map<String, dynamic>),
      lines: lines,
    );
  }
}
