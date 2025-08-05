# Bloc Implementation - Avellaneda a un Toque

## 📋 Resumen

Se ha implementado un **Bloc completo** para administrar el estado de la aplicación usando **flutter_bloc** con manejo de errores y métodos asincrónicos.

## 🏗️ Arquitectura del Bloc

### 1. Eventos (`ProductEvent`)

**Eventos de Categorías:**
- `LoadCategories`: Cargar todas las categorías
- `SelectCategory`: Seleccionar una categoría específica
- `RefreshCategories`: Actualizar categorías

**Eventos de Productos:**
- `LoadProductsByCategory`: Cargar productos por categoría
- `LoadProductDetail`: Cargar detalle de un producto
- `SearchProducts`: Buscar productos
- `LoadMoreProducts`: Cargar más productos (paginación)
- `RefreshProducts`: Actualizar productos

**Eventos de Filtros:**
- `ApplyFilters`: Aplicar filtros
- `ClearFilters`: Limpiar filtros

**Eventos de Contacto:**
- `ContactStore`: Contactar al local (llamada, WhatsApp, email)

**Eventos de Favoritos:**
- `AddToFavorites`: Agregar a favoritos
- `RemoveFromFavorites`: Remover de favoritos
- `LoadFavorites`: Cargar favoritos

### 2. Estados (`ProductState`)

**Estados de Categorías:**
- `CategoriesLoading`: Cargando categorías
- `CategoriesLoaded`: Categorías cargadas exitosamente
- `CategoriesError`: Error al cargar categorías

**Estados de Productos:**
- `ProductsLoading`: Cargando productos
- `ProductsLoaded`: Productos cargados exitosamente
- `ProductsError`: Error al cargar productos
- `LoadingMoreProducts`: Cargando más productos

**Estados de Detalle:**
- `ProductDetailLoading`: Cargando detalle
- `ProductDetailLoaded`: Detalle cargado exitosamente
- `ProductDetailError`: Error al cargar detalle

**Estados de Búsqueda:**
- `SearchLoading`: Buscando productos
- `SearchLoaded`: Búsqueda completada
- `SearchError`: Error en la búsqueda

**Estados de Contacto:**
- `ContactLoading`: Procesando contacto
- `ContactSuccess`: Contacto exitoso
- `ContactError`: Error en el contacto

**Estados de Favoritos:**
- `FavoritesLoading`: Cargando favoritos
- `FavoritesLoaded`: Favoritos cargados
- `FavoritesError`: Error al cargar favoritos

### 3. Bloc Principal (`ProductBloc`)

## 🔧 Funcionalidades Implementadas

### 1. Carga de Categorías
```dart
// Evento
context.read<ProductBloc>().add(const LoadCategories());

// Estado
if (state is CategoriesLoaded) {
  final categories = state.categories;
  // Usar categorías
}
```

### 2. Carga de Productos por Categoría
```dart
// Evento
context.read<ProductBloc>().add(LoadProductsByCategory(
  categoryId: 'cat_ropa_hombre',
  filters: {'min_price': 1000, 'max_price': 5000},
));

// Estado
if (state is ProductsLoaded) {
  final products = state.products;
  // Usar productos
}
```

### 3. Carga de Detalle de Producto
```dart
// Evento
context.read<ProductBloc>().add(LoadProductDetail('prod_001'));

// Estado
if (state is ProductDetailLoaded) {
  final product = state.product;
  final store = state.store;
  // Usar producto y local
}
```

### 4. Búsqueda de Productos
```dart
// Evento
context.read<ProductBloc>().add(SearchProducts(
  query: 'remera',
  filters: {'category': 'cat_ropa_hombre'},
));

// Estado
if (state is SearchLoaded) {
  final products = state.products;
  // Usar resultados
}
```

### 5. Contacto con el Local
```dart
// Evento
context.read<ProductBloc>().add(ContactStore(
  storeId: 'store_001',
  method: ContactMethod.whatsapp,
  product: product,
));

// Estados
if (state is ContactSuccess) {
  // Mostrar mensaje de éxito
} else if (state is ContactError) {
  // Mostrar error
}
```

### 6. Gestión de Favoritos
```dart
// Agregar a favoritos
context.read<ProductBloc>().add(AddToFavorites('prod_001'));

// Remover de favoritos
context.read<ProductBloc>().add(RemoveFromFavorites('prod_001'));

// Cargar favoritos
context.read<ProductBloc>().add(const LoadFavorites());
```

## 🎯 Manejo de Errores

### 1. Try-Catch en Métodos Asincrónicos
```dart
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
```

### 2. Estados de Error Específicos
- `CategoriesError`: Error al cargar categorías
- `ProductsError`: Error al cargar productos
- `ProductDetailError`: Error al cargar detalle
- `SearchError`: Error en búsqueda
- `ContactError`: Error en contacto
- `FavoritesError`: Error en favoritos

### 3. UI para Manejo de Errores
```dart
if (state is CategoriesError) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text('Error al cargar categorías'),
        const SizedBox(height: 8),
        Text(state.message),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            context.read<ProductBloc>().add(const LoadCategories());
          },
          child: const Text('Reintentar'),
        ),
      ],
    ),
  );
}
```

## 📱 Integración con Pantallas

### 1. Pantalla de Categorías con Bloc
```dart
class CategoriesPageWithBloc extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is CategoriesLoaded) {
          return GridView.builder(
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              return CategoryCard(
                category: state.categories[index],
                onTap: () => _navigateToProducts(context, state.categories[index]),
              );
            },
          );
        }
        
        if (state is CategoriesError) {
          return _buildErrorState(state.message);
        }
        
        return const Center(child: Text('No hay categorías'));
      },
    );
  }
}
```

### 2. Pantalla de Productos con Bloc
```dart
class ProductListPageWithBloc extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductsByCategory(
      categoryId: widget.categoryId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is ProductsLoaded) {
          return MasonryGridView.count(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: state.products[index],
                onTap: () => _navigateToProductDetail(state.products[index]),
              );
            },
          );
        }
        
        if (state is ProductsError) {
          return _buildErrorState(state.message);
        }
        
        return _buildEmptyState();
      },
    );
  }
}
```

### 3. Pantalla de Detalle con Bloc
```dart
class ProductDetailPageWithBloc extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductDetail(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is ProductDetailLoaded) {
          return _buildProductDetail(state.product, state.store);
        }
        
        if (state is ProductDetailError) {
          return _buildErrorState(state.message);
        }
        
        return const Center(child: Text('Producto no encontrado'));
      },
    );
  }
}
```

## 🔄 Métodos Asincrónicos

### 1. Carga de Datos
```dart
Future<void> _onLoadCategories(
  LoadCategories event,
  Emitter<ProductState> emit,
) async {
  try {
    emit(CategoriesLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simular API
    final categories = _getMockCategories();
    emit(CategoriesLoaded(categories: categories));
  } catch (e) {
    emit(CategoriesError('Error al cargar categorías: ${e.toString()}'));
  }
}
```

### 2. Contacto con Apps Externas
```dart
Future<void> _onContactStore(
  ContactStore event,
  Emitter<ProductState> emit,
) async {
  try {
    emit(ContactLoading(event.method));
    
    bool success = false;
    switch (event.method) {
      case ContactMethod.phone:
        success = await _makePhoneCall(store.phone);
        break;
      case ContactMethod.whatsapp:
        success = await _openWhatsApp(store.whatsapp, event.message, event.product);
        break;
      case ContactMethod.email:
        success = await _sendEmail(store.email, event.message, event.product);
        break;
    }
    
    if (success) {
      emit(ContactSuccess(event.method, 'Contacto exitoso'));
    } else {
      emit(ContactError(event.method, 'No se pudo realizar el contacto'));
    }
  } catch (e) {
    emit(ContactError(event.method, 'Error: ${e.toString()}'));
  }
}
```

### 3. Gestión de Favoritos
```dart
Future<void> _onAddToFavorites(
  AddToFavorites event,
  Emitter<ProductState> emit,
) async {
  try {
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
    }
  } catch (e) {
    emit(FavoritesError('Error al agregar a favoritos: ${e.toString()}'));
  }
}
```

## 📦 Dependencias Utilizadas

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.3
  
  # Async
  dartz: ^0.10.1
  
  # URL Launcher
  url_launcher: ^6.2.1
```

## 🎯 Características Destacadas

### 1. Manejo Completo de Estados
- ✅ Estados de carga
- ✅ Estados de éxito
- ✅ Estados de error
- ✅ Estados específicos por funcionalidad

### 2. Métodos Asincrónicos
- ✅ Carga de datos simulada
- ✅ Contacto con apps externas
- ✅ Gestión de favoritos
- ✅ Búsqueda en tiempo real

### 3. Manejo de Errores
- ✅ Try-catch en todos los métodos async
- ✅ Estados de error específicos
- ✅ UI para mostrar errores
- ✅ Botones de reintento

### 4. Funcionalidades de Contacto
- ✅ Llamada telefónica
- ✅ WhatsApp con mensaje predefinido
- ✅ Email con información del producto
- ✅ Integración con apps nativas

### 5. Gestión de Favoritos
- ✅ Agregar/remover productos
- ✅ Persistencia local (preparado)
- ✅ Estados de carga y error

## 🚀 Próximos Pasos

1. **Integración con APIs Reales**
   - Reemplazar datos mock con llamadas HTTP
   - Implementar repositorios reales
   - Manejo de tokens de autenticación

2. **Persistencia Local**
   - SharedPreferences para favoritos
   - Hive para caché de productos
   - SQLite para historial

3. **Testing**
   - Unit tests para el Bloc
   - Widget tests para las pantallas
   - Integration tests

4. **Funcionalidades Adicionales**
   - Notificaciones push
   - Modo offline
   - Sincronización de datos 