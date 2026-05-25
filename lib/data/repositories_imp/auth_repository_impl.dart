import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keen_official_app/data/graphql/auth_queries.dart';
import 'package:keen_official_app/data/services/storefront_api_service.dart';
import 'package:keen_official_app/data/utils/storefront_config.dart';
import 'package:keen_official_app/domain/models/customer_model.dart';
import 'package:keen_official_app/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository] using Shopify Storefront GraphQL API.
class AuthRepositoryImpl implements AuthRepository {
  final StorefrontApiService _api;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._api, this._storage);

  // ── Sign Up ────────────────────────────────────────────────────────────────

  @override
  Future<AuthResult<CustomerModel>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    bool acceptsMarketing = false,
  }) async {
    try {
      final data = await _api.execute(
        query: AuthQueries.customerCreate,
        variables: {
          'input': {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'password': password,
            'acceptsMarketing': acceptsMarketing,
          },
        },
      );

      final result = data['customerCreate'] as Map<String, dynamic>;
      final userErrors = result['customerUserErrors'] as List<dynamic>;

      if (userErrors.isNotEmpty) {
        final msg = userErrors
            .map((e) => (e as Map<String, dynamic>)['message'])
            .join('\n');
        return AuthResult.failure(msg);
      }

      // After sign-up, log in automatically to get the token
      return login(email: email, password: password);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // ── Login ──────────────────────────────────────────────────────────────────

  @override
  Future<AuthResult<CustomerModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Get access token
      final tokenData = await _api.execute(
        query: AuthQueries.customerAccessTokenCreate,
        variables: {
          'input': {'email': email, 'password': password},
        },
      );

      final tokenResult =
          tokenData['customerAccessTokenCreate'] as Map<String, dynamic>;
      final tokenErrors = tokenResult['customerUserErrors'] as List<dynamic>;

      if (tokenErrors.isNotEmpty) {
        final msg = tokenErrors
            .map((e) => (e as Map<String, dynamic>)['message'])
            .join('\n');
        return AuthResult.failure(msg);
      }

      final tokenJson =
          tokenResult['customerAccessToken'] as Map<String, dynamic>;
      final token = CustomerAccessToken.fromJson(tokenJson);

      // 2. Persist token securely
      await _persistToken(token, email);

      // 3. Fetch customer data
      final customer = await _fetchCustomer(token.accessToken);
      if (customer == null) {
        return AuthResult.failure('Failed to fetch customer data after login.');
      }

      return AuthResult.success(customer);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  @override
  Future<void> logout() async {
    final token = await getStoredAccessToken();
    if (token != null) {
      try {
        await _api.execute(
          query: AuthQueries.customerAccessTokenDelete,
          variables: {'customerAccessToken': token},
        );
      } catch (_) {
        // Best-effort; always clear local storage
      }
    }
    await _clearToken();
  }

  // ── Fetch Current Customer ─────────────────────────────────────────────────

  @override
  Future<CustomerModel?> fetchCurrentCustomer() async {
    final token = await getStoredAccessToken();
    if (token == null) return null;

    // Check expiry
    final expiryStr =
        await _storage.read(key: StorefrontConfig.kCustomerTokenExpiry);
    if (expiryStr != null) {
      final expiry = DateTime.tryParse(expiryStr);
      if (expiry != null && DateTime.now().isAfter(expiry)) {
        await _clearToken();
        return null;
      }
    }

    return _fetchCustomer(token);
  }

  // ── isLoggedIn ─────────────────────────────────────────────────────────────

  @override
  Future<bool> isLoggedIn() async {
    final token = await getStoredAccessToken();
    if (token == null) return false;

    final expiryStr =
        await _storage.read(key: StorefrontConfig.kCustomerTokenExpiry);
    if (expiryStr == null) return false;

    final expiry = DateTime.tryParse(expiryStr);
    return expiry != null && DateTime.now().isBefore(expiry);
  }

  // ── getStoredAccessToken ───────────────────────────────────────────────────

  @override
  Future<String?> getStoredAccessToken() async {
    return _storage.read(key: StorefrontConfig.kCustomerToken);
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<CustomerModel?> _fetchCustomer(String accessToken) async {
    try {
      final data = await _api.execute(
        query: AuthQueries.getCustomer,
        variables: {'customerAccessToken': accessToken},
      );
      final customerJson = data['customer'];
      if (customerJson == null) return null;
      return CustomerModel.fromJson(customerJson as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistToken(CustomerAccessToken token, String email) async {
    await Future.wait([
      _storage.write(
          key: StorefrontConfig.kCustomerToken, value: token.accessToken),
      _storage.write(
          key: StorefrontConfig.kCustomerTokenExpiry,
          value: token.expiresAt.toIso8601String()),
      _storage.write(key: StorefrontConfig.kCustomerEmail, value: email),
    ]);
  }

  Future<void> _clearToken() async {
    await Future.wait([
      _storage.delete(key: StorefrontConfig.kCustomerToken),
      _storage.delete(key: StorefrontConfig.kCustomerTokenExpiry),
      _storage.delete(key: StorefrontConfig.kCustomerEmail),
    ]);
  }
}
