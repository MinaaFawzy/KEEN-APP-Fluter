/// All Shopify Storefront GraphQL queries/mutations for cart operations.
class CartQueries {
  // ── Create Cart ────────────────────────────────────────────────────────────
  static const String cartCreate = r'''
    mutation cartCreate($input: CartInput!) {
      cartCreate(input: $input) {
        cart {
          id
          checkoutUrl
          totalQuantity
          cost {
            totalAmount { amount currencyCode }
            subtotalAmount { amount currencyCode }
            totalTaxAmount { amount currencyCode }
          }
          lines(first: 100) {
            edges {
              node {
                id
                quantity
                merchandise {
                  ... on ProductVariant {
                    id
                    title
                    price { amount currencyCode }
                    compareAtPrice { amount currencyCode }
                    availableForSale
                    image { url altText width height }
                    product {
                      id
                      title
                      handle
                      vendor
                    }
                    selectedOptions { name value }
                  }
                }
                cost {
                  totalAmount { amount currencyCode }
                  amountPerQuantity { amount currencyCode }
                }
              }
            }
          }
        }
        userErrors { field message code }
      }
    }
  ''';

  // ── Add Lines ──────────────────────────────────────────────────────────────
  static const String cartLinesAdd = r'''
    mutation cartLinesAdd($cartId: ID!, $lines: [CartLineInput!]!) {
      cartLinesAdd(cartId: $cartId, lines: $lines) {
        cart {
          id
          checkoutUrl
          totalQuantity
          cost {
            totalAmount { amount currencyCode }
            subtotalAmount { amount currencyCode }
            totalTaxAmount { amount currencyCode }
          }
          lines(first: 100) {
            edges {
              node {
                id
                quantity
                merchandise {
                  ... on ProductVariant {
                    id
                    title
                    price { amount currencyCode }
                    compareAtPrice { amount currencyCode }
                    availableForSale
                    image { url altText width height }
                    product {
                      id
                      title
                      handle
                      vendor
                    }
                    selectedOptions { name value }
                  }
                }
                cost {
                  totalAmount { amount currencyCode }
                  amountPerQuantity { amount currencyCode }
                }
              }
            }
          }
        }
        userErrors { field message code }
      }
    }
  ''';

  // ── Remove Lines ───────────────────────────────────────────────────────────
  static const String cartLinesRemove = r'''
    mutation cartLinesRemove($cartId: ID!, $lineIds: [ID!]!) {
      cartLinesRemove(cartId: $cartId, lineIds: $lineIds) {
        cart {
          id
          checkoutUrl
          totalQuantity
          cost {
            totalAmount { amount currencyCode }
            subtotalAmount { amount currencyCode }
            totalTaxAmount { amount currencyCode }
          }
          lines(first: 100) {
            edges {
              node {
                id
                quantity
                merchandise {
                  ... on ProductVariant {
                    id
                    title
                    price { amount currencyCode }
                    compareAtPrice { amount currencyCode }
                    availableForSale
                    image { url altText width height }
                    product {
                      id
                      title
                      handle
                      vendor
                    }
                    selectedOptions { name value }
                  }
                }
                cost {
                  totalAmount { amount currencyCode }
                  amountPerQuantity { amount currencyCode }
                }
              }
            }
          }
        }
        userErrors { field message code }
      }
    }
  ''';

  // ── Update Lines ───────────────────────────────────────────────────────────
  static const String cartLinesUpdate = r'''
    mutation cartLinesUpdate($cartId: ID!, $lines: [CartLineUpdateInput!]!) {
      cartLinesUpdate(cartId: $cartId, lines: $lines) {
        cart {
          id
          checkoutUrl
          totalQuantity
          cost {
            totalAmount { amount currencyCode }
            subtotalAmount { amount currencyCode }
            totalTaxAmount { amount currencyCode }
          }
          lines(first: 100) {
            edges {
              node {
                id
                quantity
                merchandise {
                  ... on ProductVariant {
                    id
                    title
                    price { amount currencyCode }
                    compareAtPrice { amount currencyCode }
                    availableForSale
                    image { url altText width height }
                    product {
                      id
                      title
                      handle
                      vendor
                    }
                    selectedOptions { name value }
                  }
                }
                cost {
                  totalAmount { amount currencyCode }
                  amountPerQuantity { amount currencyCode }
                }
              }
            }
          }
        }
        userErrors { field message code }
      }
    }
  ''';

  // ── Fetch Cart ─────────────────────────────────────────────────────────────
  static const String getCart = r'''
    query getCart($cartId: ID!) {
      cart(id: $cartId) {
        id
        checkoutUrl
        totalQuantity
        cost {
          totalAmount { amount currencyCode }
          subtotalAmount { amount currencyCode }
          totalTaxAmount { amount currencyCode }
        }
        lines(first: 100) {
          edges {
            node {
              id
              quantity
              merchandise {
                ... on ProductVariant {
                  id
                  title
                  price { amount currencyCode }
                  compareAtPrice { amount currencyCode }
                  availableForSale
                  image { url altText width height }
                  product {
                    id
                    title
                    handle
                    vendor
                  }
                  selectedOptions { name value }
                }
              }
              cost {
                totalAmount { amount currencyCode }
                amountPerQuantity { amount currencyCode }
              }
            }
          }
        }
      }
    }
  ''';

  // ── Associate Cart with Customer (for logged-in users) ─────────────────────
  static const String cartBuyerIdentityUpdate = r'''
    mutation cartBuyerIdentityUpdate($cartId: ID!, $buyerIdentity: CartBuyerIdentityInput!) {
      cartBuyerIdentityUpdate(cartId: $cartId, buyerIdentity: $buyerIdentity) {
        cart {
          id
          checkoutUrl
          buyerIdentity {
            email
            phone
            customer { id email firstName lastName }
          }
        }
        userErrors { field message code }
      }
    }
  ''';
}
