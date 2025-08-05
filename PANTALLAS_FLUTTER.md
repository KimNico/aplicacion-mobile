# Pantallas de Flutter - Proyecto

## 📱 Pantallas Implementadas

### 1. Pantalla de Categorías (`CategoriesPage`)

**Ubicación:** `lib/features/product/presentation/pages/categories_page.dart`

**Características:**
- ✅ Diseño con gradiente atractivo
- ✅ Grid de categorías con iconos
- ✅ Contador de productos por categoría
- ✅ Navegación a listado de productos
- ✅ Categorías: Hombre, Mujer, Niños, Accesorios, Deportiva, Blanquería

**Funcionalidades:**
- Navegación automática al tocar una categoría
- Diseño responsive con 2 columnas
- Iconos específicos para cada categoría
- Información de cantidad de productos

### 2. Listado de Productos (`ProductListPage`)

**Ubicación:** `lib/features/product/presentation/pages/product_list_page.dart`

**Características:**
- ✅ Grid masonry con productos
- ✅ Filtros por precio y ordenamiento
- ✅ Chips de filtro rápidos
- ✅ Botón de filtros avanzados
- ✅ Estado de carga y vacío
- ✅ Navegación a detalle del producto

**Funcionalidades:**
- Filtros por rango de precio
- Ordenamiento por nombre, precio, fecha
- Búsqueda en tiempo real
- Paginación infinita (preparado)
- Filtros avanzados en bottom sheet

### 3. Detalle de Producto (`ProductDetailPage`)

**Ubicación:** `lib/features/product/presentation/pages/product_detail_page.dart`

**Características:**
- ✅ Galería de imágenes con PageView
- ✅ Indicadores de imagen
- ✅ Información completa del producto
- ✅ Estado de disponibilidad
- ✅ Información del local
- ✅ Botones de contacto (llamada, WhatsApp, email)

**Funcionalidades:**
- Galería de imágenes con zoom
- Botones de contacto directo
- Información del local con horarios
- Estados de stock (disponible, agotado, pocas unidades)
- Navegación con SliverAppBar

## 🎨 Widgets Reutilizables

### CategoryCard
**Ubicación:** `lib/features/product/presentation/widgets/category_card.dart`

**Características:**
- Diseño con gradiente
- Iconos específicos por categoría
- Contador de productos
- Efectos de sombra
- Animaciones de toque

### ProductCard
**Ubicación:** `lib/features/product/presentation/widgets/product_card.dart`

**Características:**
- Imagen con CachedNetworkImage
- Badges de disponibilidad
- Información de precio y local
- Diseño responsive
- Manejo de errores de imagen

## 🧭 Navegación con go_router

### Configuración de Rutas
**Ubicación:** `lib/core/routes/app_router.dart`

**Rutas definidas:**
```dart
/                    -> CategoriesPage
/category/:categoryId -> ProductListPage
/product/:productId   -> ProductDetailPage
```

### Características de Navegación:
- ✅ Rutas con parámetros dinámicos
- ✅ Query parameters para datos adicionales
- ✅ Navegación con nombres de ruta
- ✅ Deep linking preparado
- ✅ Historial de navegación automático

## 🎯 Funcionalidades Destacadas

### 1. Filtros Avanzados
- Rango de precios con slider
- Ordenamiento múltiple
- Filtros en tiempo real
- Bottom sheet modal

### 2. Galería de Imágenes
- PageView con múltiples imágenes
- Indicadores de posición
- Carga con placeholder
- Manejo de errores

### 3. Contacto Directo
- Llamada telefónica
- WhatsApp con mensaje predefinido
- Email con información del producto
- Integración con apps nativas

### 4. Estados de UI
- Loading states
- Empty states
- Error handling
- Responsive design

## 📦 Dependencias Utilizadas

```yaml
dependencies:
  # Navegación
  go_router: ^12.1.3
  
  # Carga de imágenes
  cached_network_image: ^3.3.0
  
  # Grid layout
  flutter_staggered_grid_view: ^0.7.0
  
  # URL Launcher
  url_launcher: ^6.2.1
  
  # Utilidades
  equatable: ^2.0.5
```

## 🎨 Diseño y UX

### Paleta de Colores
- **Primario:** Azul (#1976D2)
- **Secundario:** Verde para contacto
- **Neutros:** Grises para texto
- **Estados:** Rojo (agotado), Naranja (pocas unidades), Verde (disponible)

### Tipografía
- **Títulos:** 24px, Bold
- **Subtítulos:** 18px, Bold
- **Cuerpo:** 16px, Regular
- **Captions:** 14px, Regular

### Espaciado
- **Padding general:** 16px
- **Espaciado entre elementos:** 8px, 12px, 16px, 20px
- **Border radius:** 12px, 16px, 20px

## 🚀 Características Técnicas

### Performance
- ✅ Carga lazy de imágenes
- ✅ Caché de imágenes
- ✅ Widgets optimizados
- ✅ Estados de carga

### Accesibilidad
- ✅ Contraste adecuado
- ✅ Tamaños de toque apropiados
- ✅ Textos descriptivos
- ✅ Navegación por teclado

### Responsive
- ✅ Adaptación a diferentes pantallas
- ✅ Grid responsive
- ✅ Textos escalables
- ✅ Layout flexible

## 📱 Flujo de Usuario

1. **Pantalla de Categorías**
   - Usuario ve categorías disponibles
   - Toca una categoría para explorar

2. **Listado de Productos**
   - Ve productos de la categoría
   - Aplica filtros si desea
   - Toca un producto para ver detalles

3. **Detalle del Producto**
   - Ve imágenes y descripción
   - Consulta información del local
   - Contacta al local directamente

## 🔧 Próximos Pasos

1. **Integración con APIs**
   - Conectar con backend real
   - Implementar paginación
   - Manejo de errores de red

2. **Funcionalidades Adicionales**
   - Búsqueda global
   - Favoritos
   - Historial de navegación
   - Notificaciones

3. **Mejoras de UX**
   - Animaciones de transición
   - Pull to refresh
   - Skeleton loading
   - Offline support

4. **Testing**
   - Unit tests
   - Widget tests
   - Integration tests 