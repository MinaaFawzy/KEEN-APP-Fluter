import 'package:keen_official_app/data/repositories_imp/product_repository_imp.dart';
import 'package:keen_official_app/data/services/api_services.dart';
import 'package:keen_official_app/data/utils/app_apis.dart';
import 'package:keen_official_app/domain/repositories/product_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: AppApis.baseUrl));
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio, ref);
});

final productsDataProvider = Provider<ProductRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProductRepositoryImp(apiService);
});

