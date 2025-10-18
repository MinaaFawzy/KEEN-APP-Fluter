import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/api_provider.dart';
import 'package:keen_official_app/data/repositories_imp/product_repository_imp.dart';
import 'package:keen_official_app/domain/models/product_model.dart';
import 'package:keen_official_app/domain/repositories/product_repository.dart';


final productsTitleProvider = StateProvider<String>((ref) => 'All products');

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProductRepositoryImp(apiService);
});

final productsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('496061186267');
});

final setsProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('506530529499');
});

final backToUniProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('520757903579');
});

final dressProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('521199714523');
});

final onSaleProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('521204269275');
});

final allTopsProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('521199976667');
});

final tShirtProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('521200074971');
});

final topsProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('513054965979');
});

final shirtsProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('496158802139');
});

final bottomProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('521199812827');
});

final pantsProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('496158965979');
});

final skirtsProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('496158933211');
});

final shortsProductsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('521199517915');
});

final endOfSeasonSaleProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('521913467099');
});

final newArrivalsProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('508693184731');
});

final bestSellersProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('513105821915');
});

final fallLayersProvider = FutureProvider<List<Products>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.getCollectionProducts('521930047707');
});