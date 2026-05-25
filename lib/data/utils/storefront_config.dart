/// Shopify Storefront API configuration.
/// Replace [storefrontToken] with your actual Storefront API token
/// (different from the Admin API token).
class StorefrontConfig {
  static const String shopDomain = 'keenlocalbrand.myshopify.com';

  /// Storefront API access token — create one in Shopify Admin:
  /// Settings → Apps and sales channels → Develop apps → Storefront API access scopes
  static const String storefrontToken = '102b61a9c4177c31d3b16e6fa7ac3835';

  static const String storefrontEndpoint =
      'https://$shopDomain/api/2024-01/graphql.json';

  /// Secure-storage keys
  static const String kCustomerToken = 'customer_access_token';
  static const String kCustomerTokenExpiry = 'customer_token_expiry';
  static const String kCartId = 'shopify_cart_id';
  static const String kCustomerEmail = 'customer_email';
}
