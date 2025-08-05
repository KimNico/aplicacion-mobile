import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

// Respuesta genérica de la API
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? meta;
  final List<String>? errors;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.meta,
    this.errors,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      meta: json['meta'] != null ? Map<String, dynamic>.from(json['meta']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data!) : null,
      'meta': meta,
      'errors': errors,
    };
  }
}

// Respuesta paginada
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResponse({
    required this.data,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List).map((item) => fromJsonT(item)).toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'data': data.map((item) => toJsonT(item)).toList(),
      'meta': meta.toJson(),
    };
  }
}

// Metadatos de paginación
@JsonSerializable()
class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;
  final String? nextPageUrl;
  final String? prevPageUrl;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => _$PaginationMetaFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPreviousPage => prevPageUrl != null;
}

// Respuesta de categorías
@JsonSerializable()
class CategoriesResponse {
  final List<CategoryApiModel> categories;

  CategoriesResponse({required this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) => _$CategoriesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);
}

// Respuesta de productos
@JsonSerializable()
class ProductsResponse {
  final List<ProductApiModel> products;
  final PaginationMeta? pagination;

  ProductsResponse({
    required this.products,
    this.pagination,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) => _$ProductsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsResponseToJson(this);
}

// Respuesta de detalle de producto
@JsonSerializable()
class ProductDetailResponse {
  final ProductApiModel product;
  final StoreApiModel? store;

  ProductDetailResponse({
    required this.product,
    this.store,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) => _$ProductDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailResponseToJson(this);
}

// Modelos de datos de la API
@JsonSerializable()
class CategoryApiModel {
  final String id;
  final String name;
  final String description;
  final String? icon;
  final int productCount;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryApiModel({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    required this.productCount,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) => _$CategoryApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);
}

@JsonSerializable()
class ProductApiModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String storeId;
  final List<String> images;
  final bool isAvailable;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final Map<String, dynamic> specifications;

  ProductApiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.storeId,
    required this.images,
    required this.isAvailable,
    required this.stockQuantity,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    required this.specifications,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) => _$ProductApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);
}

@JsonSerializable()
class StoreApiModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String whatsapp;
  final String website;
  final double latitude;
  final double longitude;
  final List<String> images;
  final StoreHoursApiModel hours;
  final bool isActive;
  final List<String> categories;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreApiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.whatsapp,
    required this.website,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.hours,
    required this.isActive,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreApiModel.fromJson(Map<String, dynamic> json) => _$StoreApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoreApiModelToJson(this);
}

@JsonSerializable()
class StoreHoursApiModel {
  final Map<String, DayScheduleApiModel> schedules;
  final String specialHours;
  final bool isOpenNow;

  StoreHoursApiModel({
    required this.schedules,
    required this.specialHours,
    required this.isOpenNow,
  });

  factory StoreHoursApiModel.fromJson(Map<String, dynamic> json) => _$StoreHoursApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoreHoursApiModelToJson(this);
}

@JsonSerializable()
class DayScheduleApiModel {
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final String? breakStart;
  final String? breakEnd;

  DayScheduleApiModel({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    this.breakStart,
    this.breakEnd,
  });

  factory DayScheduleApiModel.fromJson(Map<String, dynamic> json) => _$DayScheduleApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$DayScheduleApiModelToJson(this);
}

// Respuesta de stores
@JsonSerializable()
class StoresResponse {
  final List<StoreApiModel> stores;

  StoresResponse({required this.stores});

  factory StoresResponse.fromJson(Map<String, dynamic> json) => _$StoresResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StoresResponseToJson(this);
} 