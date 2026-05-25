import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/private.dart';

class ApiService {
  final Dio _dio;
  final Ref ref;
  final shopifyToken = Private().SHOPIFY_TOKEN;

  ApiService(this._dio, this.ref);

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    print('GET Request to: ${endpoint} with params: $queryParameters');
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            "X-Shopify-Access-Token": shopifyToken,
            "Content-Type": "application/json",
          },
        ),
      );

      print(
        'Response received from: ${endpoint} Status: ${response.statusCode}',
      );

      if (response.data == null) {
        throw Exception("Server returned empty response");
      }

      return response;
    } on DioException catch (e) {
      print("DioError: ${e.type} - ${e.message}");
      print("DioError Response: ${e.response?.data}");

      throw Exception(
        "There is ERROR when getting data Please try again later: ${e.message}",
      );
    } catch (e) {
      print("Unexpected Error: $e");
      throw Exception(
        "There is unexpected ERROR getting data Please try again later",
      );
    }
  }
}
