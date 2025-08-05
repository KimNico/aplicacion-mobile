import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:url_launcher/url_launcher.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/store_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../../../../core/error/failures.dart';

class ProductBlocWithApi extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBlocWithApi({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategory>(_onSelectCategory);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<LoadProductDetail>(_onLoadProductDetail);
    on<SearchProducts>(_onSearchProducts);
    on<ApplyFilters>(_onApplyFilters);
    on<ClearFilters>(_onClearFilters);
    on<ContactStore>(_onContactStore);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<LoadFavorites>(_onLoadFavorites);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<RefreshCategories>(_onRefreshCategories);
  }

  // Cargar categorías desde API
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

  // Seleccionar categoría
  void _onSelectCategory(
    SelectCategory event,
    Emitter<ProductState> emit,
  ) {
    if (state is CategoriesLoaded) {
      final currentState = state as CategoriesLoaded;
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }

  // Cargar productos por categoría desde API
  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductsLoading());
      
      final result = await _productRepository.getProductsByCategory(
        event.categoryId,
        filters: event.filters,
      );
      
      result.fold(
        (failure) {
          if (failure is NetworkFailure) {
            emit(ProductsError(
              'No hay conexión a internet. Verifica tu conexión.',
              categoryId: event.categoryId,
            ));
          } else if (failure is ServerFailure) {
            emit(ProductsError(
              'Error del servidor: ${failure.message}',
              categoryId: event.categoryId,
            ));
          } else {
            emit(ProductsError(
              'Error al cargar productos: ${failure.message}',
              categoryId: event.categoryId,
            ));
          }
        },
        (products) {
          emit(ProductsLoaded(
            products: products,
            categoryId: event.categoryId,
            filters: event.filters,
          ));
        },
      );
    } catch (e) {
      emit(ProductsError(
        'Error inesperado: ${e.toString()}',
        categoryId: event.categoryId,
      ));
    }
  }

  // Cargar detalle de producto desde API
  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductDetailLoading());
      
      final productResult = await _productRepository.getProductDetail(event.productId);
      
      productResult.fold(
        (failure) {
          if (failure is NetworkFailure) {
            emit(ProductDetailError(
              'No hay conexión a internet. Verifica tu conexión.',
              event.productId,
            ));
          } else if (failure is ServerFailure) {
            emit(ProductDetailError(
              'Error del servidor: ${failure.message}',
              event.productId,
            ));
          } else {
            emit(ProductDetailError(
              'Error al cargar el producto: ${failure.message}',
              event.productId,
            ));
          }
        },
        (product) async {
          // Cargar información del local
          final storeResult = await _productRepository.getStoreById(product.storeId);
          
          storeResult.fold(
            (storeFailure) {
              // Si falla la carga del local, solo mostrar el producto
              emit(ProductDetailLoaded(product: product, store: null));
            },
            (store) {
              emit(ProductDetailLoaded(product: product, store: store));
            },
          );
        },
      );
    } catch (e) {
      emit(ProductDetailError(
        'Error inesperado: ${e.toString()}',
        event.productId,
      ));
    }
  }

  // Buscar productos desde API
  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(SearchLoading());
      
      final result = await _productRepository.searchProducts(
        event.query,
        filters: event.filters,
      );
      
      result.fold(
        (failure) {
          if (failure is NetworkFailure) {
            emit(SearchError(
              'No hay conexión a internet. Verifica tu conexión.',
              event.query,
            ));
          } else if (failure is ServerFailure) {
            emit(SearchError(
              'Error del servidor: ${failure.message}',
              event.query,
            ));
          } else {
            emit(SearchError(
              'Error en la búsqueda: ${failure.message}',
              event.query,
            ));
          }
        },
        (products) {
          emit(SearchLoaded(
            products: products,
            query: event.query,
            filters: event.filters,
          ));
        },
      );
    } catch (e) {
      emit(SearchError(
        'Error inesperado: ${e.toString()}',
        event.query,
      ));
    }
  }

  // Aplicar filtros
  void _onApplyFilters(
    ApplyFilters event,
    Emitter<ProductState> emit,
  ) {
    emit(FiltersApplied(event.filters));
  }

  // Limpiar filtros
  void _onClearFilters(
    ClearFilters event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(currentState.copyWith(filters: null));
    }
  }

  // Contactar al local
  Future<void> _onContactStore(
    ContactStore event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ContactLoading(event.method));
      // Obtener información del local
      final storeResult = await _productRepository.getStoreById(event.storeId);
      storeResult.fold(
        (failure) {
          emit(ContactError(
            event.method,
            'No se pudo obtener información del local: ${failure.message}',
          ));
        },
        (store) async {
          // Extraer datos reales de la tienda
          final String phone = store.phone;
          final String whatsapp = store.whatsapp;
          final String email = store.email;
          final String website = store.website;
          bool success = false;
          String message = '';

          switch (event.method) {
            case ContactMethod.phone:
              success = await _makePhoneCall(phone);
              message = success ? 'Llamada iniciada' : 'No se pudo realizar la llamada';
              break;
            case ContactMethod.whatsapp:
              success = await _openWhatsApp(whatsapp, event.message, event.product);
              message = success ? 'WhatsApp abierto' : 'No se pudo abrir WhatsApp';
              break;
            case ContactMethod.email:
              success = await _sendEmail(email, event.message, event.product);
              message = success ? 'Email abierto' : 'No se pudo abrir el email';
              break;
            case ContactMethod.website:
              success = await _openWebsite(website);
              message = success ? 'Sitio web abierto' : 'No se pudo abrir el sitio web';
              break;
          }

          if (success) {
            emit(ContactSuccess(event.method, message));
          } else {
            emit(ContactError(event.method, message));
          }
        },
      );
    } catch (e) {
      emit(ContactError(
        event.method,
        'Error al contactar: ${e.toString()}',
      ));
    }
  }

  // Agregar a favoritos (mantener lógica local)
  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<ProductState> emit,
  ) async {
    try {
      // Aquí se guardaría en SharedPreferences o base de datos local
      // Por ahora, simulamos la funcionalidad
      
      if (state is FavoritesLoaded) {
        final currentState = state as FavoritesLoaded;
        final newFavorites = List<ProductModel>.from(currentState.favorites);
        final newFavoriteIds = List<String>.from(currentState.favoriteIds);
        
        if (!newFavoriteIds.contains(event.productId)) {
          // Buscar el producto en el estado actual
          ProductModel? productToAdd;
          
          if (state is ProductsLoaded) {
            final productsState = state as ProductsLoaded;
            productToAdd = productsState.products.firstWhere(
              (product) => product.id == event.productId,
              orElse: () => _getMockProductById(event.productId),
            );
          } else if (state is ProductDetailLoaded) {
            final detailState = state as ProductDetailLoaded;
            if (detailState.product.id == event.productId) {
              productToAdd = detailState.product;
            }
          }
          
          if (productToAdd != null) {
            newFavorites.add(productToAdd);
            newFavoriteIds.add(event.productId);
          }
        }
        
        emit(FavoritesLoaded(
          favorites: newFavorites,
          favoriteIds: newFavoriteIds,
        ));
      } else {
        // Crear nuevo estado de favoritos
        final product = _getMockProductById(event.productId);
        emit(FavoritesLoaded(
          favorites: [product],
          favoriteIds: [event.productId],
        ));
      }
    } catch (e) {
      emit(FavoritesError('Error al agregar a favoritos: ${e.toString()}'));
    }
  }

  // Remover de favoritos
  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is FavoritesLoaded) {
        final currentState = state as FavoritesLoaded;
        final newFavorites = currentState.favorites
            .where((product) => product.id != event.productId)
            .toList();
        final newFavoriteIds = currentState.favoriteIds
            .where((id) => id != event.productId)
            .toList();
        
        emit(FavoritesLoaded(
          favorites: newFavorites,
          favoriteIds: newFavoriteIds,
        ));
      }
    } catch (e) {
      emit(FavoritesError('Error al remover de favoritos: ${e.toString()}'));
    }
  }

  // Cargar favoritos
  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(FavoritesLoading());
      
      // Simular carga desde SharedPreferences
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Aquí se cargarían desde almacenamiento local
      final favorites = <ProductModel>[];
      final favoriteIds = <String>[];
      
      emit(FavoritesLoaded(
        favorites: favorites,
        favoriteIds: favoriteIds,
      ));
    } catch (e) {
      emit(FavoritesError('Error al cargar favoritos: ${e.toString()}'));
    }
  }

  // Cargar más productos (paginación)
  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      
      if (!currentState.hasReachedMax) {
        emit(LoadingMoreProducts(currentState.products));
        
        try {
          // Calcular página siguiente
          final nextPage = currentState.currentPage + 1;
          final filters = Map<String, dynamic>.from(currentState.filters ?? {});
          filters['page'] = nextPage;
          
          final result = await _productRepository.getProductsByCategory(
            currentState.categoryId,
            filters: filters,
          );
          
          result.fold(
            (failure) {
              emit(ProductsError(
                'Error al cargar más productos: ${failure.message}',
                categoryId: currentState.categoryId,
              ));
            },
            (newProducts) {
              if (newProducts.isEmpty) {
                // No hay más productos
                emit(currentState.copyWith(hasReachedMax: true));
              } else {
                // Agregar nuevos productos
                final allProducts = [...currentState.products, ...newProducts];
                emit(currentState.copyWith(
                  products: allProducts,
                  currentPage: nextPage,
                  hasReachedMax: newProducts.length < 20, // Asumiendo 20 por página
                ));
              }
            },
          );
        } catch (e) {
          emit(ProductsError(
            'Error inesperado: ${e.toString()}',
            categoryId: currentState.categoryId,
          ));
        }
      }
    }
  }

  // Refresh productos
  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(ProductsLoading(isRefreshing: true));
      
      try {
        final result = await _productRepository.getProductsByCategory(
          currentState.categoryId,
          filters: currentState.filters,
        );
        
        result.fold(
          (failure) {
            emit(ProductsError(
              'Error al actualizar productos: ${failure.message}',
              categoryId: currentState.categoryId,
            ));
          },
          (products) {
            emit(ProductsLoaded(
              products: products,
              categoryId: currentState.categoryId,
              filters: currentState.filters,
            ));
          },
        );
      } catch (e) {
        emit(ProductsError(
          'Error inesperado: ${e.toString()}',
          categoryId: currentState.categoryId,
        ));
      }
    }
  }

  // Refresh categorías
  Future<void> _onRefreshCategories(
    RefreshCategories event,
    Emitter<ProductState> emit,
  ) async {
    emit(Refreshing('categories'));
    
    try {
      final result = await _productRepository.getCategories();
      
      result.fold(
        (failure) {
          emit(CategoriesError('Error al actualizar categorías: ${failure.message}'));
        },
        (categories) {
          emit(CategoriesLoaded(categories: categories));
        },
      );
    } catch (e) {
      emit(CategoriesError('Error inesperado: ${e.toString()}'));
    }
  }

  // Métodos de contacto
  Future<bool> _makePhoneCall(String phone) async {
    final url = 'tel:$phone';
    return await canLaunchUrl(Uri.parse(url)) &&
           await launchUrl(Uri.parse(url));
  }

  Future<bool> _openWhatsApp(String phone, String? message, ProductModel? product) async {
    final defaultMessage = product != null 
        ? 'Hola! Me interesa el producto: ${product.name}'
        : 'Hola! Me gustaría hacer una consulta';
    final finalMessage = message ?? defaultMessage;
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(finalMessage)}';
    return await canLaunchUrl(Uri.parse(url)) &&
           await launchUrl(Uri.parse(url));
  }

  Future<bool> _sendEmail(String email, String? message, ProductModel? product) async {
    final subject = product != null 
        ? 'Consulta sobre: ${product.name}'
        : 'Consulta sobre productos';
    final body = product != null
        ? 'Hola! Me interesa el producto: ${product.name}\n\nPrecio: \$${product.price}\n\nSaludos!'
        : 'Hola! Me gustaría hacer una consulta sobre sus productos.\n\nSaludos!';
    final finalBody = message ?? body;
    final url = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(finalBody)}';
    return await canLaunchUrl(Uri.parse(url)) &&
           await launchUrl(Uri.parse(url));
  }

  Future<bool> _openWebsite(String website) async {
    final url = website.startsWith('http') ? website : 'https://$website';
    return await canLaunchUrl(Uri.parse(url)) &&
           await launchUrl(Uri.parse(url));
  }

  // Método auxiliar para obtener producto mock (fallback)
  ProductModel _getMockProductById(String productId) {
    return const ProductModel(
      id: 'prod_001',
      name: 'Producto de ejemplo',
      description: 'Descripción del producto',
      price: 1000.0,
      categoryId: 'cat_001',
      storeId: 'store_001',
      images: ['https://picsum.photos/300/400?random=1'],
      isAvailable: true,
      stockQuantity: 10,
      createdAt: null,
      updatedAt: null,
    );
  }
} 