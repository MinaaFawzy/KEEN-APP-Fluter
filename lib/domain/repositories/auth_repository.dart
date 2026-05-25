import 'package:keen_official_app/domain/models/customer_model.dart';

/// Encapsulates the result of an auth operation.
/// Either [data] is non-null (success) or [error] is non-null (failure).
class AuthResult<T> {
  final T? data;
  final String? error;

  const AuthResult.success(this.data) : error = null;
  const AuthResult.failure(this.error) : data = null;

  bool get isSuccess => error == null;
}

/// Abstract contract for customer authentication.
abstract class AuthRepository {
  /// Register a new customer. Returns the created [CustomerModel].
  Future<AuthResult<CustomerModel>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    bool acceptsMarketing = false,
  });

  /// Log in with [email] + [password]. Persists token securely.
  Future<AuthResult<CustomerModel>> login({
    required String email,
    required String password,
  });

  /// Log out the current customer. Deletes token from secure storage.
  Future<void> logout();

  /// Fetch the currently logged-in customer using the stored token.
  /// Returns null if not authenticated.
  Future<CustomerModel?> fetchCurrentCustomer();

  /// Whether a valid (non-expired) token exists in secure storage.
  Future<bool> isLoggedIn();

  /// Retrieve the stored access token (or null).
  Future<String?> getStoredAccessToken();
}
