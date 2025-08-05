import 'dart:convert';
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.categoryId,
    required super.storeId,
    required super.images,
    super.isAvailable = true,
    super.stockQuantity = 0,
    super.createdAt,
    super.updatedAt,
    super.tags = const [],
    super.specifications = const {},
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['category_id'] as String,
      storeId: json['store_id'] as String,
      images: List<String>.from(json['images'] as List),
      isAvailable: json['is_available'] as bool? ?? true,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'] as List)
          : const [],
      specifications: json['specifications'] != null 
          ? Map<String, dynamic>.from(json['specifications'] as Map)
          : const {},
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      categoryId: product.categoryId,
      storeId: product.storeId,
      images: product.images,
      isAvailable: product.isAvailable,
      stockQuantity: product.stockQuantity,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      tags: product.tags,
      specifications: product.specifications,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'store_id': storeId,
      'images': images,
      'is_available': isAvailable,
      'stock_quantity': stockQuantity,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'tags': tags,
      'specifications': specifications,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    String? storeId,
    List<String>? images,
    bool? isAvailable,
    int? stockQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    Map<String, dynamic>? specifications,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      storeId: storeId ?? this.storeId,
      images: images ?? this.images,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
    );
  }

  static List<ProductModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ProductModel> products) {
    return products.map((product) => product.toJson()).toList();
  }
} 