import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String storeId;
  final List<String> images;
  final bool isAvailable;
  final int stockQuantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final Map<String, dynamic> specifications;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.storeId,
    required this.images,
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.specifications = const {},
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        categoryId,
        storeId,
        images,
        isAvailable,
        stockQuantity,
        createdAt,
        updatedAt,
        tags,
        specifications,
      ];

  Product copyWith({
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
    return Product(
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
} 