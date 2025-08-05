// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  meta: json['meta'] as Map<String, dynamic>?,
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'meta': instance.meta,
  'errors': instance.errors,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginatedResponse<T>(
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'meta': instance.meta,
};

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(
      currentPage: (json['currentPage'] as num).toInt(),
      lastPage: (json['lastPage'] as num).toInt(),
      perPage: (json['perPage'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      from: (json['from'] as num).toInt(),
      to: (json['to'] as num).toInt(),
      nextPageUrl: json['nextPageUrl'] as String?,
      prevPageUrl: json['prevPageUrl'] as String?,
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'perPage': instance.perPage,
      'total': instance.total,
      'from': instance.from,
      'to': instance.to,
      'nextPageUrl': instance.nextPageUrl,
      'prevPageUrl': instance.prevPageUrl,
    };

CategoriesResponse _$CategoriesResponseFromJson(Map<String, dynamic> json) =>
    CategoriesResponse(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoriesResponseToJson(CategoriesResponse instance) =>
    <String, dynamic>{'categories': instance.categories};

ProductsResponse _$ProductsResponseFromJson(Map<String, dynamic> json) =>
    ProductsResponse(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : PaginationMeta.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductsResponseToJson(ProductsResponse instance) =>
    <String, dynamic>{
      'products': instance.products,
      'pagination': instance.pagination,
    };

ProductDetailResponse _$ProductDetailResponseFromJson(
  Map<String, dynamic> json,
) => ProductDetailResponse(
  product: ProductApiModel.fromJson(json['product'] as Map<String, dynamic>),
  store: json['store'] == null
      ? null
      : StoreApiModel.fromJson(json['store'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductDetailResponseToJson(
  ProductDetailResponse instance,
) => <String, dynamic>{'product': instance.product, 'store': instance.store};

CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    CategoryApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      productCount: (json['productCount'] as num).toInt(),
      sortOrder: (json['sortOrder'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CategoryApiModelToJson(CategoryApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'productCount': instance.productCount,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      storeId: json['storeId'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isAvailable: json['isAvailable'] as bool,
      stockQuantity: (json['stockQuantity'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      specifications: json['specifications'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'categoryId': instance.categoryId,
      'storeId': instance.storeId,
      'images': instance.images,
      'isAvailable': instance.isAvailable,
      'stockQuantity': instance.stockQuantity,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'tags': instance.tags,
      'specifications': instance.specifications,
    };

StoreApiModel _$StoreApiModelFromJson(Map<String, dynamic> json) =>
    StoreApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      whatsapp: json['whatsapp'] as String,
      website: json['website'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      hours: StoreHoursApiModel.fromJson(json['hours'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StoreApiModelToJson(StoreApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'whatsapp': instance.whatsapp,
      'website': instance.website,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'images': instance.images,
      'hours': instance.hours,
      'isActive': instance.isActive,
      'categories': instance.categories,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

StoreHoursApiModel _$StoreHoursApiModelFromJson(Map<String, dynamic> json) =>
    StoreHoursApiModel(
      schedules: (json['schedules'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          DayScheduleApiModel.fromJson(e as Map<String, dynamic>),
        ),
      ),
      specialHours: json['specialHours'] as String,
      isOpenNow: json['isOpenNow'] as bool,
    );

Map<String, dynamic> _$StoreHoursApiModelToJson(StoreHoursApiModel instance) =>
    <String, dynamic>{
      'schedules': instance.schedules,
      'specialHours': instance.specialHours,
      'isOpenNow': instance.isOpenNow,
    };

DayScheduleApiModel _$DayScheduleApiModelFromJson(Map<String, dynamic> json) =>
    DayScheduleApiModel(
      isOpen: json['isOpen'] as bool,
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      breakStart: json['breakStart'] as String?,
      breakEnd: json['breakEnd'] as String?,
    );

Map<String, dynamic> _$DayScheduleApiModelToJson(
  DayScheduleApiModel instance,
) => <String, dynamic>{
  'isOpen': instance.isOpen,
  'openTime': instance.openTime,
  'closeTime': instance.closeTime,
  'breakStart': instance.breakStart,
  'breakEnd': instance.breakEnd,
};

StoresResponse _$StoresResponseFromJson(Map<String, dynamic> json) =>
    StoresResponse(
      stores: (json['stores'] as List<dynamic>)
          .map((e) => StoreApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoresResponseToJson(StoresResponse instance) =>
    <String, dynamic>{'stores': instance.stores};
