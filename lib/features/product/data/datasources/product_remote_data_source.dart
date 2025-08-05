import 'package:dartz/dartz.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/store_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String categoryId, {Map<String, dynamic>? filters});
  Future<ProductModel> getProductDetail(String productId);
  Future<List<ProductModel>> searchProducts(String query, {Map<String, dynamic>? filters});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient _apiClient;

  ProductRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/categories');
      
      if (response.data == null) {
        throw ApiException('No se recibieron datos de categorías', response.statusCode);
      }

      final categoriesResponse = CategoriesResponse.fromJson(response.data!);
      
      return categoriesResponse.categories.map((categoryApi) {
        return CategoryModel(
          id: categoryApi.id,
          name: categoryApi.name,
          description: categoryApi.description,
          icon: categoryApi.icon,
          productCount: categoryApi.productCount,
          sortOrder: categoryApi.sortOrder,
          createdAt: categoryApi.createdAt,
          updatedAt: categoryApi.updatedAt,
        );
      }).toList();
    } catch (e) {
      throw ApiException('Error al obtener categorías: ${e.toString()}', null);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(
    String categoryId, {
    Map<String, dynamic>? filters,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'categoryId': categoryId,
        'page': filters?['page'] ?? 1,
        'perPage': filters?['perPage'] ?? 20,
      };

      // Agregar filtros adicionales
      if (filters != null) {
        if (filters['minPrice'] != null) {
          queryParams['minPrice'] = filters['minPrice'];
        }
        if (filters['maxPrice'] != null) {
          queryParams['maxPrice'] = filters['maxPrice'];
        }
        if (filters['sort'] != null) {
          queryParams['sort'] = filters['sort'];
        }
        if (filters['available'] != null) {
          queryParams['available'] = filters['available'];
        }
      }

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/products',
        queryParameters: queryParams,
      );

      if (response.data == null) {
        throw ApiException('No se recibieron datos de productos', response.statusCode);
      }

      final productsResponse = ProductsResponse.fromJson(response.data!);
      
      return productsResponse.products.map((productApi) {
        return ProductModel(
          id: productApi.id,
          name: productApi.name,
          description: productApi.description,
          price: productApi.price,
          categoryId: productApi.categoryId,
          storeId: productApi.storeId,
          images: productApi.images,
          isAvailable: productApi.isAvailable,
          stockQuantity: productApi.stockQuantity,
          createdAt: productApi.createdAt,
          updatedAt: productApi.updatedAt,
          tags: productApi.tags,
          specifications: productApi.specifications,
        );
      }).toList();
    } catch (e) {
      throw ApiException('Error al obtener productos: ${e.toString()}', null);
    }
  }

  @override
  Future<ProductModel> getProductDetail(String productId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/products/$productId');

      if (response.data == null) {
        throw ApiException('No se recibieron datos del producto', response.statusCode);
      }

      final productDetailResponse = ProductDetailResponse.fromJson(response.data!);
      
      return ProductModel(
        id: productDetailResponse.product.id,
        name: productDetailResponse.product.name,
        description: productDetailResponse.product.description,
        price: productDetailResponse.product.price,
        categoryId: productDetailResponse.product.categoryId,
        storeId: productDetailResponse.product.storeId,
        images: productDetailResponse.product.images,
        isAvailable: productDetailResponse.product.isAvailable,
        stockQuantity: productDetailResponse.product.stockQuantity,
        createdAt: productDetailResponse.product.createdAt,
        updatedAt: productDetailResponse.product.updatedAt,
        tags: productDetailResponse.product.tags,
        specifications: productDetailResponse.product.specifications,
      );
    } catch (e) {
      throw ApiException('Error al obtener detalle del producto: ${e.toString()}', null);
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(
    String query, {
    Map<String, dynamic>? filters,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        'page': filters?['page'] ?? 1,
        'perPage': filters?['perPage'] ?? 20,
      };

      // Agregar filtros adicionales
      if (filters != null) {
        if (filters['categoryId'] != null) {
          queryParams['categoryId'] = filters['categoryId'];
        }
        if (filters['minPrice'] != null) {
          queryParams['minPrice'] = filters['minPrice'];
        }
        if (filters['maxPrice'] != null) {
          queryParams['maxPrice'] = filters['maxPrice'];
        }
        if (filters['sort'] != null) {
          queryParams['sort'] = filters['sort'];
        }
        if (filters['available'] != null) {
          queryParams['available'] = filters['available'];
        }
      }

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/products/search',
        queryParameters: queryParams,
      );

      if (response.data == null) {
        throw ApiException('No se recibieron resultados de búsqueda', response.statusCode);
      }

      final productsResponse = ProductsResponse.fromJson(response.data!);
      
      return productsResponse.products.map((productApi) {
        return ProductModel(
          id: productApi.id,
          name: productApi.name,
          description: productApi.description,
          price: productApi.price,
          categoryId: productApi.categoryId,
          storeId: productApi.storeId,
          images: productApi.images,
          isAvailable: productApi.isAvailable,
          stockQuantity: productApi.stockQuantity,
          createdAt: productApi.createdAt,
          updatedAt: productApi.updatedAt,
          tags: productApi.tags,
          specifications: productApi.specifications,
        );
      }).toList();
    } catch (e) {
      throw ApiException('Error en la búsqueda: ${e.toString()}', null);
    }
  }
} 