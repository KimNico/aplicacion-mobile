# API Integration - Avellaneda a un Toque

## 📋 Resumen

Se ha implementado una **integración completa con API REST** usando **Dio** para consumir los endpoints de categorías y productos, con manejo de errores y arquitectura Clean Architecture.

## 🏗️ Arquitectura de la API

### 1. Cliente API (`ApiClient`)
```dart
class ApiClient {
  static const String _baseUrl = 'https://api.avellaneda-a-un-toque.com/v1';
  static const String _apiKey = 'your-api-key-here';
  
  late final Dio _dio;
  
  // Métodos HTTP genéricos
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters});
  Future<Response<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Response<T>> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<Response<T>> delete<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters});
}
```

### 2. Modelos de Respuesta (`ApiResponse`)
```dart
// Respuesta genérica
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? meta;
  final List<String>? errors;
}

// Respuesta paginada
class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;
}

// Respuestas específicas
class CategoriesResponse {
  final List<CategoryApiModel> categories;
}

class ProductsResponse {
  final List<ProductApiModel> products;
  final PaginationMeta? pagination;
}

class ProductDetailResponse {
  final ProductApiModel product;
  final StoreApiModel? store;
}
```

## 🔌 Endpoints Implementados

### 1. GET /categories
**Descripción**: Obtener todas las categorías disponibles

**Respuesta**:
```json
{
  "success": true,
  "data": {
    "categories": [
      {
        "id": "cat_ropa_hombre",
        "name": "Hombre",
        "description": "Ropa para hombres",
        "icon": "assets/icons/men.png",
        "productCount": 150,
        "sortOrder": 1,
        "createdAt": "2024-01-01T00:00:00Z",
        "updatedAt": "2024-01-01T00:00:00Z"
      }
    ]
  }
}
```

**Implementación**:
```dart
Future<List<CategoryModel>> getCategories() async {
  final response = await _apiClient.get<Map<String, dynamic>>('/categories');
  final categoriesResponse = CategoriesResponse.fromJson(response.data!);
  return categoriesResponse.categories.map((categoryApi) {
    return CategoryModel.fromApiModel(categoryApi);
  }).toList();
}
```

### 2. GET /products?categoryId={id}
**Descripción**: Obtener productos por categoría con filtros opcionales

**Parámetros de consulta**:
- `categoryId` (requerido): ID de la categoría
- `page` (opcional): Número de página (default: 1)
- `perPage` (opcional): Productos por página (default: 20)
- `minPrice` (opcional): Precio mínimo
- `maxPrice` (opcional): Precio máximo
- `sort` (opcional): Ordenamiento (price_asc, price_desc, name_asc, date)
- `available` (opcional): Solo productos disponibles

**Respuesta**:
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": "prod_001",
        "name": "Remera de Algodón",
        "description": "Remera 100% algodón",
        "price": 2500.0,
        "categoryId": "cat_ropa_hombre",
        "storeId": "store_001",
        "images": ["https://example.com/image1.jpg"],
        "isAvailable": true,
        "stockQuantity": 15,
        "tags": ["algodón", "básico"],
        "specifications": {
          "material": "100% algodón",
          "talles": ["S", "M", "L", "XL"]
        },
        "createdAt": "2024-01-01T00:00:00Z",
        "updatedAt": "2024-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "lastPage": 5,
      "perPage": 20,
      "total": 100,
      "from": 1,
      "to": 20,
      "nextPageUrl": "https://api.example.com/products?page=2",
      "prevPageUrl": null
    }
  }
}
```

**Implementación**:
```dart
Future<List<ProductModel>> getProductsByCategory(
  String categoryId, {
  Map<String, dynamic>? filters,
}) async {
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

  final productsResponse = ProductsResponse.fromJson(response.data!);
  return productsResponse.products.map((productApi) {
    return ProductModel.fromApiModel(productApi);
  }).toList();
}
```

### 3. GET /products/{id}
**Descripción**: Obtener detalle completo de un producto

**Respuesta**:
```json
{
  "success": true,
  "data": {
    "product": {
      "id": "prod_001",
      "name": "Remera de Algodón Premium",
      "description": "Remera 100% algodón de alta calidad...",
      "price": 2500.0,
      "categoryId": "cat_ropa_hombre",
      "storeId": "store_001",
      "images": [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg"
      ],
      "isAvailable": true,
      "stockQuantity": 15,
      "tags": ["algodón", "premium", "básico"],
      "specifications": {
        "material": "100% algodón",
        "talles": ["S", "M", "L", "XL"],
        "colores": ["blanco", "negro", "gris"]
      },
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-01T00:00:00Z"
    },
    "store": {
      "id": "store_001",
      "name": "Ropa Avellaneda",
      "description": "Local de ropa en el centro de Avellaneda",
      "address": "Av. Mitre 123, Avellaneda, Buenos Aires",
      "phone": "+54 11 1234-5678",
      "email": "info@ropaavellaneda.com",
      "whatsapp": "+54 11 9876-5432",
      "website": "https://ropaavellaneda.com",
      "latitude": -34.6617,
      "longitude": -58.3647,
      "images": ["https://example.com/store1.jpg"],
      "hours": {
        "schedules": {
          "monday": {
            "isOpen": true,
            "openTime": "09:00",
            "closeTime": "18:00"
          }
        },
        "specialHours": "",
        "isOpenNow": true
      },
      "isActive": true,
      "categories": ["cat_ropa_hombre", "cat_ropa_mujer"],
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-01T00:00:00Z"
    }
  }
}
```

**Implementación**:
```dart
Future<ProductModel> getProductDetail(String productId) async {
  final response = await _apiClient.get<Map<String, dynamic>>('/products/$productId');
  final productDetailResponse = ProductDetailResponse.fromJson(response.data!);
  return ProductModel.fromApiModel(productDetailResponse.product);
}
```

### 4. GET /products/search?q={query}
**Descripción**: Buscar productos por nombre o descripción

**Parámetros de consulta**:
- `q` (requerido): Término de búsqueda
- `categoryId` (opcional): Filtrar por categoría
- `minPrice` (opcional): Precio mínimo
- `maxPrice` (opcional): Precio máximo
- `sort` (opcional): Ordenamiento
- `available` (opcional): Solo productos disponibles

**Implementación**:
```dart
Future<List<ProductModel>> searchProducts(
  String query, {
  Map<String, dynamic>? filters,
}) async {
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

  final productsResponse = ProductsResponse.fromJson(response.data!);
  return productsResponse.products.map((productApi) {
    return ProductModel.fromApiModel(productApi);
  }).toList();
}
```

## 🔧 Data Sources

### 1. ProductRemoteDataSource
```dart
abstract class ProductRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String categoryId, {Map<String, dynamic>? filters});
  Future<ProductModel> getProductDetail(String productId);
  Future<List<ProductModel>> searchProducts(String query, {Map<String, dynamic>? filters});
}
```

### 2. StoreRemoteDataSource
```dart
abstract class StoreRemoteDataSource {
  Future<StoreModel> getStoreById(String storeId);
  Future<List<StoreModel>> getStoresByCategory(String categoryId);
  Future<List<StoreModel>> searchStores(String query);
}
```

## 🎯 Manejo de Errores

### 1. Excepciones Personalizadas
```dart
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, this.statusCode);
}
```

### 2. Failures para Clean Architecture
```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}
```

### 3. Manejo en Data Sources
```dart
try {
  final response = await _apiClient.get<Map<String, dynamic>>('/categories');
  
  if (response.data == null) {
    throw ApiException('No se recibieron datos de categorías', response.statusCode);
  }

  final categoriesResponse = CategoriesResponse.fromJson(response.data!);
  return categoriesResponse.categories.map((categoryApi) {
    return CategoryModel.fromApiModel(categoryApi);
  }).toList();
} catch (e) {
  throw ApiException('Error al obtener categorías: ${e.toString()}', null);
}
```

## 🔄 Repository Pattern

### 1. ProductRepositoryImpl
```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final StoreRemoteDataSource _storeDataSource;
  final NetworkInfo _networkInfo;

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
}
```

## 🎯 Bloc con API Real

### 1. ProductBlocWithApi
```dart
class ProductBlocWithApi extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(CategoriesLoading());
      
      final result = await _productRepository.getCategories();
      
      result.fold(
        (failure) {
          if (failure is NetworkFailure) {
            emit(CategoriesError('No hay conexión a internet. Verifica tu conexión.'));
          } else if (failure is ServerFailure) {
            emit(CategoriesError('Error del servidor: ${failure.message}'));
          } else {
            emit(CategoriesError('Error al cargar categorías: ${failure.message}'));
          }
        },
        (categories) {
          emit(CategoriesLoaded(categories: categories));
        },
      );
    } catch (e) {
      emit(CategoriesError('Error inesperado: ${e.toString()}'));
    }
  }
}
```

## 📦 Dependencias Agregadas

```yaml
dependencies:
  # HTTP Client
  dio: ^5.3.2
  
  # JSON Serialization
  json_annotation: ^4.8.1
  
  # Connectivity
  connectivity_plus: ^5.0.2
  
  # Functional Programming
  dartz: ^0.10.1
```

## 🔧 Configuración

### 1. Inyección de Dependencias
```dart
Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => ProductBlocWithApi(productRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      storeDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(),
  );
}
```

### 2. Inicialización en main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}
```

## 🎯 Características Destacadas

### 1. Manejo Completo de Errores
- ✅ Excepciones específicas para red y API
- ✅ Failures para Clean Architecture
- ✅ Manejo de estados de error en Bloc
- ✅ UI para mostrar errores con reintento

### 2. Filtros y Paginación
- ✅ Filtros por precio, categoría, disponibilidad
- ✅ Ordenamiento por precio, nombre, fecha
- ✅ Paginación automática
- ✅ Carga infinita de productos

### 3. Búsqueda Avanzada
- ✅ Búsqueda por nombre y descripción
- ✅ Filtros combinados en búsqueda
- ✅ Resultados paginados

### 4. Información de Stores
- ✅ Detalle completo del local
- ✅ Horarios de atención
- ✅ Información de contacto
- ✅ Geolocalización

## 🚀 Próximos Pasos

1. **Autenticación**
   - Implementar JWT tokens
   - Refresh tokens automático
   - Interceptor de autenticación

2. **Caché Local**
   - SharedPreferences para datos básicos
   - Hive para productos y categorías
   - Estrategia offline-first

3. **Testing**
   - Unit tests para data sources
   - Integration tests para API
   - Mock responses para testing

4. **Optimizaciones**
   - Compresión de imágenes
   - Lazy loading
   - Prefetching de datos

5. **Monitoreo**
   - Logging de errores
   - Métricas de rendimiento
   - Analytics de uso 