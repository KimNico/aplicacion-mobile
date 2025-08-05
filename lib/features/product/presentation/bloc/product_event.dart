import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// Eventos para categorías
class LoadCategories extends ProductEvent {
  const LoadCategories();
}

class SelectCategory extends ProductEvent {
  final CategoryModel category;

  const SelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}

// Eventos para productos
class LoadProductsByCategory extends ProductEvent {
  final String categoryId;
  final Map<String, dynamic>? filters;

  const LoadProductsByCategory({
    required this.categoryId,
    this.filters,
  });

  @override
  List<Object?> get props => [categoryId, filters];
}

class LoadProductDetail extends ProductEvent {
  final String productId;

  const LoadProductDetail(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SearchProducts extends ProductEvent {
  final String query;
  final Map<String, dynamic>? filters;

  const SearchProducts({
    required this.query,
    this.filters,
  });

  @override
  List<Object?> get props => [query, filters];
}

class ApplyFilters extends ProductEvent {
  final Map<String, dynamic> filters;

  const ApplyFilters(this.filters);

  @override
  List<Object?> get props => [filters];
}

class ClearFilters extends ProductEvent {
  const ClearFilters();
}

// Eventos para contacto
class ContactStore extends ProductEvent {
  final String storeId;
  final ContactMethod method;
  final String? message;
  final ProductModel? product;

  const ContactStore({
    required this.storeId,
    required this.method,
    this.message,
    this.product,
  });

  @override
  List<Object?> get props => [storeId, method, message, product];
}

// Eventos para favoritos
class AddToFavorites extends ProductEvent {
  final String productId;

  const AddToFavorites(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RemoveFromFavorites extends ProductEvent {
  final String productId;

  const RemoveFromFavorites(this.productId);

  @override
  List<Object?> get props => [productId];
}

class LoadFavorites extends ProductEvent {
  const LoadFavorites();
}

// Eventos para paginación
class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

// Eventos para refresh
class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}

class RefreshCategories extends ProductEvent {
  const RefreshCategories();
}

// Enum para métodos de contacto
enum ContactMethod {
  phone,
  whatsapp,
  email,
  website,
} 