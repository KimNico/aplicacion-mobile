import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/store_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

// Estados iniciales
class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

// Estados para categorías
class CategoriesLoading extends ProductState {}

class CategoriesLoaded extends ProductState {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;

  const CategoriesLoaded({
    required this.categories,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [categories, selectedCategory];

  CategoriesLoaded copyWith({
    List<CategoryModel>? categories,
    CategoryModel? selectedCategory,
  }) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class CategoriesError extends ProductState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Estados para productos
class ProductsLoading extends ProductState {
  final bool isRefreshing;

  const ProductsLoading({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;
  final String categoryId;
  final Map<String, dynamic>? filters;
  final bool hasReachedMax;
  final int currentPage;

  const ProductsLoaded({
    required this.products,
    required this.categoryId,
    this.filters,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [
        products,
        categoryId,
        filters,
        hasReachedMax,
        currentPage,
      ];

  ProductsLoaded copyWith({
    List<ProductModel>? products,
    String? categoryId,
    Map<String, dynamic>? filters,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      categoryId: categoryId ?? this.categoryId,
      filters: filters ?? this.filters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ProductsError extends ProductState {
  final String message;
  final String? categoryId;

  const ProductsError(this.message, {this.categoryId});

  @override
  List<Object?> get props => [message, categoryId];
}

// Estados para detalle de producto
class ProductDetailLoading extends ProductState {}

class ProductDetailLoaded extends ProductState {
  final ProductModel product;
  final StoreModel? store;

  const ProductDetailLoaded({
    required this.product,
    this.store,
  });

  @override
  List<Object?> get props => [product, store];
}

class ProductDetailError extends ProductState {
  final String message;
  final String productId;

  const ProductDetailError(this.message, this.productId);

  @override
  List<Object?> get props => [message, productId];
}

// Estados para búsqueda
class SearchLoading extends ProductState {}

class SearchLoaded extends ProductState {
  final List<ProductModel> products;
  final String query;
  final Map<String, dynamic>? filters;

  const SearchLoaded({
    required this.products,
    required this.query,
    this.filters,
  });

  @override
  List<Object?> get props => [products, query, filters];
}

class SearchError extends ProductState {
  final String message;
  final String query;

  const SearchError(this.message, this.query);

  @override
  List<Object?> get props => [message, query];
}

// Estados para contacto
class ContactLoading extends ProductState {
  final ContactMethod method;

  const ContactLoading(this.method);

  @override
  List<Object?> get props => [method];
}

class ContactSuccess extends ProductState {
  final ContactMethod method;
  final String message;

  const ContactSuccess(this.method, this.message);

  @override
  List<Object?> get props => [method, message];
}

class ContactError extends ProductState {
  final ContactMethod method;
  final String message;

  const ContactError(this.method, this.message);

  @override
  List<Object?> get props => [method, message];
}

// Estados para favoritos
class FavoritesLoading extends ProductState {}

class FavoritesLoaded extends ProductState {
  final List<ProductModel> favorites;
  final List<String> favoriteIds;

  const FavoritesLoaded({
    required this.favorites,
    required this.favoriteIds,
  });

  @override
  List<Object?> get props => [favorites, favoriteIds];

  FavoritesLoaded copyWith({
    List<ProductModel>? favorites,
    List<String>? favoriteIds,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

class FavoritesError extends ProductState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Estados para filtros
class FiltersApplied extends ProductState {
  final Map<String, dynamic> filters;

  const FiltersApplied(this.filters);

  @override
  List<Object?> get props => [filters];
}

// Estados para paginación
class LoadingMoreProducts extends ProductState {
  final List<ProductModel> currentProducts;

  const LoadingMoreProducts(this.currentProducts);

  @override
  List<Object?> get props => [currentProducts];
}

// Estados para refresh
class Refreshing extends ProductState {
  final String type; // 'categories', 'products', 'favorites'

  const Refreshing(this.type);

  @override
  List<Object?> get props => [type];
}

// Enum para métodos de contacto (duplicado para evitar import circular)
enum ContactMethod {
  phone,
  whatsapp,
  email,
  website,
} 