import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/store.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/store_remote_data_source.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/store_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final StoreRemoteDataSource _storeDataSource;
  final NetworkInfo _networkInfo;

  ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
    required StoreRemoteDataSource storeDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _storeDataSource = storeDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final categories = await _remoteDataSource.getCategories();
        return Right(categories);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(
    String categoryId, {
    Map<String, dynamic>? filters,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final products = await _remoteDataSource.getProductsByCategory(
          categoryId,
          filters: filters,
        );
        return Right(products);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductDetail(String productId) async {
    if (await _networkInfo.isConnected) {
      try {
        final product = await _remoteDataSource.getProductDetail(productId);
        return Right(product);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts(
    String query, {
    Map<String, dynamic>? filters,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final products = await _remoteDataSource.searchProducts(
          query,
          filters: filters,
        );
        return Right(products);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, StoreModel>> getStoreById(String storeId) async {
    if (await _networkInfo.isConnected) {
      try {
        final store = await _storeDataSource.getStoreById(storeId);
        return Right(store);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<StoreModel>>> getStoresByCategory(String categoryId) async {
    if (await _networkInfo.isConnected) {
      try {
        final stores = await _storeDataSource.getStoresByCategory(categoryId);
        return Right(stores);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<StoreModel>>> searchStores(String query) async {
    if (await _networkInfo.isConnected) {
      try {
        final stores = await _storeDataSource.searchStores(query);
        return Right(stores);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }
} 