import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/store_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();

  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(
    String categoryId, {
    Map<String, dynamic>? filters,
  });

  Future<Either<Failure, ProductModel>> getProductDetail(String productId);

  Future<Either<Failure, List<ProductModel>>> searchProducts(
    String query, {
    Map<String, dynamic>? filters,
  });

  Future<Either<Failure, StoreModel>> getStoreById(String storeId);

  Future<Either<Failure, List<StoreModel>>> getStoresByCategory(String categoryId);

  Future<Either<Failure, List<StoreModel>>> searchStores(String query);
}
