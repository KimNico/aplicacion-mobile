import 'dart:convert';
import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.description,
    super.parentId,
    required super.icon,
    super.productCount = 0,
    super.isActive = true,
    super.sortOrder = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      parentId: json['parent_id'] as String?,
      icon: json['icon'] as String,
      productCount: json['product_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      parentId: category.parentId,
      icon: category.icon,
      productCount: category.productCount,
      isActive: category.isActive,
      sortOrder: category.sortOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'parent_id': parentId,
      'icon': icon,
      'product_count': productCount,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? parentId,
    String? icon,
    int? productCount,
    bool? isActive,
    int? sortOrder,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      icon: icon ?? this.icon,
      productCount: productCount ?? this.productCount,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  static List<CategoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<CategoryModel> categories) {
    return categories.map((category) => category.toJson()).toList();
  }
} 