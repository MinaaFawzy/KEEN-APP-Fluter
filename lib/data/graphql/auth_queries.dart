/// All Shopify Storefront GraphQL queries/mutations for authentication.
class AuthQueries {
  // ── Sign Up ────────────────────────────────────────────────────────────────
  static const String customerCreate = r'''
    mutation customerCreate($input: CustomerCreateInput!) {
      customerCreate(input: $input) {
        customer {
          id
          firstName
          lastName
          email
          phone
          acceptsMarketing
          createdAt
        }
        customerUserErrors {
          code
          field
          message
        }
      }
    }
  ''';

  // ── Login ──────────────────────────────────────────────────────────────────
  static const String customerAccessTokenCreate = r'''
    mutation customerAccessTokenCreate($input: CustomerAccessTokenCreateInput!) {
      customerAccessTokenCreate(input: $input) {
        customerAccessToken {
          accessToken
          expiresAt
        }
        customerUserErrors {
          code
          field
          message
        }
      }
    }
  ''';

  // ── Logout ─────────────────────────────────────────────────────────────────
  static const String customerAccessTokenDelete = r'''
    mutation customerAccessTokenDelete($customerAccessToken: String!) {
      customerAccessTokenDelete(customerAccessToken: $customerAccessToken) {
        deletedAccessToken
        deletedCustomerAccessTokenId
        userErrors {
          field
          message
        }
      }
    }
  ''';

  // ── Fetch Customer ─────────────────────────────────────────────────────────
  static const String getCustomer = r'''
    query getCustomer($customerAccessToken: String!) {
      customer(customerAccessToken: $customerAccessToken) {
        id
        firstName
        lastName
        email
        phone
        acceptsMarketing
        createdAt
        orders(first: 5, sortKey: PROCESSED_AT, reverse: true) {
          edges {
            node {
              id
              name
              orderNumber
              totalPrice {
                amount
                currencyCode
              }
              processedAt
              fulfillmentStatus
              financialStatus
            }
          }
        }
        defaultAddress {
          id
          firstName
          lastName
          address1
          address2
          city
          country
          province
          zip
          phone
        }
      }
    }
  ''';

  // ── Renew Token ────────────────────────────────────────────────────────────
  static const String customerAccessTokenRenew = r'''
    mutation customerAccessTokenRenew($customerAccessToken: String!) {
      customerAccessTokenRenew(customerAccessToken: $customerAccessToken) {
        customerAccessToken {
          accessToken
          expiresAt
        }
        userErrors {
          field
          message
        }
      }
    }
  ''';
}
