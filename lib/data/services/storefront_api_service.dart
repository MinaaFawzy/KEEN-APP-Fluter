import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:keen_official_app/data/utils/storefront_config.dart';

/// Low-level HTTP service that sends GraphQL requests to the Shopify Storefront API.
/// All auth & cart services depend on this.
class StorefrontApiService {
  final Dio _dio;

  StorefrontApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: StorefrontConfig.storefrontEndpoint,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'X-Shopify-Storefront-Access-Token':
                  StorefrontConfig.storefrontToken,
              'Accept': 'application/json',
            },
          ),
        );

  /// Execute a GraphQL operation.
  /// Returns the `data` map on success, or throws a [StorefrontException].
  Future<Map<String, dynamic>> execute({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    try {
      final body = jsonEncode({
        'query': query,
        if (variables != null) 'variables': variables,
      });

      final response = await _dio.post(
        '',
        data: body,
      );

      final json = response.data as Map<String, dynamic>;

      // GraphQL-level errors
      if (json.containsKey('errors')) {
        final errors = json['errors'] as List<dynamic>;
        final message = errors
            .map((e) => (e as Map<String, dynamic>)['message'])
            .join(', ');
        throw StorefrontException(message);
      }

      return json['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseBody = e.response?.data?.toString() ?? '';
      throw StorefrontException(
        'Network error ($statusCode): ${e.message}\n$responseBody',
      );
    } catch (e) {
      if (e is StorefrontException) rethrow;
      throw StorefrontException('Unexpected error: $e');
    }
  }
}

class StorefrontException implements Exception {
  final String message;
  const StorefrontException(this.message);

  @override
  String toString() => 'StorefrontException: $message';
}
