import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keen_official_app/data/repositories_imp/auth_repository_impl.dart';
import 'package:keen_official_app/data/services/storefront_api_service.dart';
import 'package:keen_official_app/domain/models/customer_model.dart';
import 'package:keen_official_app/domain/repositories/auth_repository.dart';

// ── Infrastructure providers ───────────────────────────────────────────────

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  ),
);

final storefrontApiServiceProvider = Provider<StorefrontApiService>(
  (_) => StorefrontApiService(),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(storefrontApiServiceProvider),
    ref.watch(secureStorageProvider),
  );
});

// ── Auth State ─────────────────────────────────────────────────────────────

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final CustomerModel? customer;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.customer,
    this.errorMessage,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    CustomerModel? customer,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        customer: customer ?? this.customer,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

// ── Auth Notifier ──────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState.initial()) {
    _initSession();
  }

  /// On app start: restore session if a valid token exists.
  Future<void> _initSession() async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final loggedIn = await _repo.isLoggedIn();
      if (loggedIn) {
        final customer = await _repo.fetchCurrentCustomer();
        if (customer != null) {
          state = AuthState(
              status: AuthStatus.authenticated, customer: customer);
          return;
        }
      }
    } catch (_) {}
    state = AuthState(status: AuthStatus.unauthenticated);
  }

  // ── Public Actions ─────────────────────────────────────────────────────

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    bool acceptsMarketing = false,
  }) async {
    state = AuthState(status: AuthStatus.loading);
    final result = await _repo.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      acceptsMarketing: acceptsMarketing,
    );

    if (result.isSuccess) {
      state = AuthState(
          status: AuthStatus.authenticated, customer: result.data);
      return true;
    }
    state = AuthState(
        status: AuthStatus.error, errorMessage: result.error);
    return false;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = AuthState(status: AuthStatus.loading);
    final result = await _repo.login(email: email, password: password);

    if (result.isSuccess) {
      state = AuthState(
          status: AuthStatus.authenticated, customer: result.data);
      return true;
    }
    state = AuthState(
        status: AuthStatus.error, errorMessage: result.error);
    return false;
  }

  Future<void> logout() async {
    state = AuthState(status: AuthStatus.loading);
    await _repo.logout();
    state = AuthState(status: AuthStatus.unauthenticated);
  }

  Future<String?> getAccessToken() => _repo.getStoredAccessToken();

  void clearError() {
    if (state.status == AuthStatus.error) {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }
}

// ── Provider ───────────────────────────────────────────────────────────────

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

/// Convenience provider to check auth status
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Convenience provider for the customer
final currentCustomerProvider = Provider<CustomerModel?>((ref) {
  return ref.watch(authProvider).customer;
});
