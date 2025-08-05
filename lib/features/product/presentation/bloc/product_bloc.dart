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

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
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

  // Cargar categorías
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(CategoriesLoading());
      
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));
      
      final categories = _getMockCategories();
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(CategoriesError('Error al cargar categorías: ${e.toString()}'));
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

  // Cargar productos por categoría
  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductsLoading());
      
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));
      
      final products = _getMockProductsByCategory(event.categoryId);
      emit(ProductsLoaded(
        products: products,
        categoryId: event.categoryId,
        filters: event.filters,
      ));
    } catch (e) {
      emit(ProductsError(
        'Error al cargar productos: ${e.toString()}',
        categoryId: event.categoryId,
      ));
    }
  }

  // Cargar detalle de producto
  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductDetailLoading());
      
      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));
      
      final product = _getMockProductById(event.productId);
      final store = _getMockStoreById(product.storeId);
      
      emit(ProductDetailLoaded(product: product, store: store));
    } catch (e) {
      emit(ProductDetailError(
        'Error al cargar detalle del producto: ${e.toString()}',
        event.productId,
      ));
    }
  }

  // Buscar productos
  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(SearchLoading());
      
      // Simular llamada a API
      await Future.delayed(const Duration(milliseconds: 500));
      
      final allProducts = _getAllMockProducts();
      final filteredProducts = allProducts.where((product) {
        return product.name.toLowerCase().contains(event.query.toLowerCase()) ||
               product.description.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      
      emit(SearchLoaded(
        products: filteredProducts,
        query: event.query,
        filters: event.filters,
      ));
    } catch (e) {
      emit(SearchError(
        'Error en la búsqueda: ${e.toString()}',
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
      
      final store = _getMockStoreById(event.storeId);
      bool success = false;
      String message = '';

      switch (event.method) {
        case ContactMethod.phone:
          success = await _makePhoneCall(store.phone);
          message = success ? 'Llamada iniciada' : 'No se pudo realizar la llamada';
          break;
        case ContactMethod.whatsapp:
          success = await _openWhatsApp(store.whatsapp, event.message, event.product);
          message = success ? 'WhatsApp abierto' : 'No se pudo abrir WhatsApp';
          break;
        case ContactMethod.email:
          success = await _sendEmail(store.email, event.message, event.product);
          message = success ? 'Email abierto' : 'No se pudo abrir el email';
          break;
        case ContactMethod.website:
          success = await _openWebsite(store.website);
          message = success ? 'Sitio web abierto' : 'No se pudo abrir el sitio web';
          break;
      }

      if (success) {
        emit(ContactSuccess(event.method, message));
      } else {
        emit(ContactError(event.method, message));
      }
    } catch (e) {
      emit(ContactError(
        event.method,
        'Error al contactar: ${e.toString()}',
      ));
    }
  }

  // Agregar a favoritos
  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<ProductState> emit,
  ) async {
    try {
      // Aquí se guardaría en SharedPreferences o base de datos local
      final product = _getMockProductById(event.productId);
      
      if (state is FavoritesLoaded) {
        final currentState = state as FavoritesLoaded;
        final newFavorites = List<ProductModel>.from(currentState.favorites);
        final newFavoriteIds = List<String>.from(currentState.favoriteIds);
        
        if (!newFavoriteIds.contains(event.productId)) {
          newFavorites.add(product);
          newFavoriteIds.add(event.productId);
        }
        
        emit(FavoritesLoaded(
          favorites: newFavorites,
          favoriteIds: newFavoriteIds,
        ));
      } else {
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
          await Future.delayed(const Duration(seconds: 1));
          
          // Simular carga de más productos
          final moreProducts = _getMockProductsByCategory(currentState.categoryId);
          final allProducts = [...currentState.products, ...moreProducts];
          
          emit(currentState.copyWith(
            products: allProducts,
            currentPage: currentState.currentPage + 1,
            hasReachedMax: allProducts.length >= 50, // Límite simulado
          ));
        } catch (e) {
          emit(ProductsError(
            'Error al cargar más productos: ${e.toString()}',
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
        await Future.delayed(const Duration(seconds: 1));
        
        final products = _getMockProductsByCategory(currentState.categoryId);
        emit(ProductsLoaded(
          products: products,
          categoryId: currentState.categoryId,
          filters: currentState.filters,
        ));
      } catch (e) {
        emit(ProductsError(
          'Error al actualizar productos: ${e.toString()}',
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
      await Future.delayed(const Duration(seconds: 1));
      
      final categories = _getMockCategories();
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(CategoriesError('Error al actualizar categorías: ${e.toString()}'));
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

  // Datos mock
  List<CategoryModel> _getMockCategories() {
    return [
      const CategoryModel(
        id: 'cat_ropa_hombre',
        name: 'Hombre',
        description: 'Ropa para hombres',
        icon: 'assets/icons/men.png',
        productCount: 150,
        sortOrder: 1,
        createdAt: null,
        updatedAt: null,
      ),
      const CategoryModel(
        id: 'cat_ropa_mujer',
        name: 'Mujer',
        description: 'Ropa para mujeres',
        icon: 'assets/icons/women.png',
        productCount: 200,
        sortOrder: 2,
        createdAt: null,
        updatedAt: null,
      ),
      const CategoryModel(
        id: 'cat_ropa_ninos',
        name: 'Niños',
        description: 'Ropa para niños',
        icon: 'assets/icons/kids.png',
        productCount: 80,
        sortOrder: 3,
        createdAt: null,
        updatedAt: null,
      ),
      const CategoryModel(
        id: 'cat_accesorios',
        name: 'Accesorios',
        description: 'Accesorios de moda',
        icon: 'assets/icons/accessories.png',
        productCount: 120,
        sortOrder: 4,
        createdAt: null,
        updatedAt: null,
      ),
      const CategoryModel(
        id: 'cat_deportiva',
        name: 'Deportiva',
        description: 'Ropa deportiva',
        icon: 'assets/icons/sports.png',
        productCount: 90,
        sortOrder: 5,
        createdAt: null,
        updatedAt: null,
      ),
      const CategoryModel(
        id: 'cat_blanqueria',
        name: 'Blanquería',
        description: 'Ropa interior y pijamas',
        icon: 'assets/icons/underwear.png',
        productCount: 60,
        sortOrder: 6,
        createdAt: null,
        updatedAt: null,
      ),
    ];
  }

  List<ProductModel> _getMockProductsByCategory(String categoryId) {
    final allProducts = _getAllMockProducts();
    return allProducts.where((product) => product.categoryId == categoryId).toList();
  }

  ProductModel _getMockProductById(String productId) {
    final allProducts = _getAllMockProducts();
    return allProducts.firstWhere((product) => product.id == productId);
  }

  StoreModel _getMockStoreById(String storeId) {
    return const StoreModel(
      id: 'store_001',
      name: 'Ropa Avellaneda',
      description: 'Local de ropa en el centro de Avellaneda',
      address: 'Av. Mitre 123, Avellaneda, Buenos Aires',
      phone: '+54 11 1234-5678',
      email: 'info@ropaavellaneda.com',
      whatsapp: '+54 11 9876-5432',
      website: 'https://ropaavellaneda.com',
      latitude: -34.6617,
      longitude: -58.3647,
      images: [],
      hours: null,
      createdAt: null,
      updatedAt: null,
    );
  }

  List<ProductModel> _getAllMockProducts() {
    return [
      const ProductModel(
        id: 'prod_001',
        name: 'Remera de Algodón',
        description: 'Remera 100% algodón, cómoda y transpirable',
        price: 2500.0,
        categoryId: 'cat_ropa_hombre',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=1',
          'https://picsum.photos/300/400?random=2',
        ],
        isAvailable: true,
        stockQuantity: 15,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_002',
        name: 'Pantalón Jean',
        description: 'Pantalón jean clásico, perfecto para cualquier ocasión',
        price: 3500.0,
        categoryId: 'cat_ropa_hombre',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=3',
        ],
        isAvailable: true,
        stockQuantity: 8,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_003',
        name: 'Camisa Formal',
        description: 'Camisa elegante para eventos especiales',
        price: 4200.0,
        categoryId: 'cat_ropa_hombre',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=4',
        ],
        isAvailable: true,
        stockQuantity: 12,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_004',
        name: 'Vestido Elegante',
        description: 'Vestido elegante para ocasiones especiales',
        price: 5500.0,
        categoryId: 'cat_ropa_mujer',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=5',
        ],
        isAvailable: true,
        stockQuantity: 6,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_005',
        name: 'Zapatillas Deportivas',
        description: 'Zapatillas ideales para deporte y casual',
        price: 5500.0,
        categoryId: 'cat_deportiva',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=6',
        ],
        isAvailable: true,
        stockQuantity: 6,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_006',
        name: 'Cinturón de Cuero',
        description: 'Cinturón elegante de cuero genuino',
        price: 1800.0,
        categoryId: 'cat_accesorios',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=7',
        ],
        isAvailable: true,
        stockQuantity: 25,
        createdAt: null,
        updatedAt: null,
      ),
    ];
  }
} 