# Entidades del Dominio - Proyecto

## 🏗️ Entidades Principales

### 1. Product (Producto)
```dart
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String categoryId;
  final String storeId;
  final bool isAvailable;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final Map<String, dynamic> specifications;
}
```

### 2. Category (Categoría)
```dart
class Category {
  final String id;
  final String name;
  final String description;
  final String? parentId;
  final String icon;
  final int productCount;
  final bool isActive;
  final int sortOrder;
}
```

### 3. Store (Local)
```dart
class Store {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String whatsapp;
  final String website;
  final double latitude;
  final double longitude;
  final List<String> images;
  final StoreHours hours;
  final bool isActive;
  final List<String> categories;
}
```

### 4. StoreHours (Horarios del Local)
```dart
class StoreHours {
  final Map<DayOfWeek, DaySchedule> schedules;
  final String specialHours;
  final bool isOpenNow;
}
```

### 5. DaySchedule (Horario Diario)
```dart
class DaySchedule {
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final String? breakStart;
  final String? breakEnd;
}
```

### 6. User (Usuario)
```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final List<String> favoriteProducts;
  final List<String> favoriteStores;
  final UserPreferences preferences;
  final DateTime createdAt;
  final DateTime lastLogin;
}
```

### 7. UserPreferences (Preferencias del Usuario)
```dart
class UserPreferences {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String language;
  final String currency;
  final List<String> preferredCategories;
  final double maxPrice;
  final double minPrice;
}
```

### 8. SearchHistory (Historial de Búsqueda)
```dart
class SearchHistory {
  final String id;
  final String userId;
  final String query;
  final SearchType type;
  final DateTime searchedAt;
  final Map<String, dynamic> filters;
}
```

### 9. Notification (Notificación)
```dart
class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final String? productId;
  final String? storeId;
  final bool isRead;
  final DateTime createdAt;
}
```

---

## 🔄 Enums y Tipos

### SearchType
```dart
enum SearchType {
  product,
  store,
  category,
  general
}
```

### NotificationType
```dart
enum NotificationType {
  priceChange,
  newProduct,
  stockUpdate,
  promotion,
  general
}
```

### DayOfWeek
```dart
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}
```

### ContactMethod
```dart
enum ContactMethod {
  phone,
  whatsapp,
  email,
  website
}
```

---

## 📊 Filtros y Criterios

### ProductFilter
```dart
class ProductFilter {
  final List<String> categoryIds;
  final double? minPrice;
  final double? maxPrice;
  final List<String> storeIds;
  final bool? isAvailable;
  final String? searchQuery;
  final SortOrder sortOrder;
  final int page;
  final int limit;
}
```

### SortOrder
```dart
enum SortOrder {
  priceAsc,
  priceDesc,
  nameAsc,
  nameDesc,
  newest,
  mostPopular
}
```

---

## 🎯 Casos de Uso Relacionados

### 1. GetProductsByCategory
- **Entrada**: categoryId, filters
- **Salida**: List<Product>
- **Descripción**: Obtener productos filtrados por categoría

### 2. GetProductDetails
- **Entrada**: productId
- **Salida**: ProductDetail (Product + Store info)
- **Descripción**: Obtener detalles completos del producto

### 3. SearchProducts
- **Entrada**: query, filters
- **Salida**: List<Product>
- **Descripción**: Búsqueda de productos

### 4. GetStoresByCategory
- **Entrada**: categoryId
- **Salida**: List<Store>
- **Descripción**: Obtener locales por categoría

### 5. ContactStore
- **Entrada**: storeId, contactMethod, message
- **Salida**: bool
- **Descripción**: Contactar al local

### 6. AddToFavorites
- **Entrada**: userId, productId
- **Salida**: bool
- **Descripción**: Agregar producto a favoritos

### 7. GetUserFavorites
- **Entrada**: userId
- **Salida**: List<Product>
- **Descripción**: Obtener productos favoritos

### 8. UpdateSearchHistory
- **Entrada**: userId, query, type
- **Salida**: void
- **Descripción**: Actualizar historial de búsqueda

---

## 🔗 Relaciones entre Entidades

### Product ↔ Category
- Un producto pertenece a una categoría
- Una categoría puede tener múltiples productos

### Product ↔ Store
- Un producto pertenece a un local
- Un local puede tener múltiples productos

### User ↔ Product (Favoritos)
- Un usuario puede tener múltiples productos favoritos
- Un producto puede ser favorito de múltiples usuarios

### User ↔ Store (Favoritos)
- Un usuario puede tener múltiples locales favoritos
- Un local puede ser favorito de múltiples usuarios

### Category ↔ Category (Jerarquía)
- Una categoría puede tener subcategorías
- Una categoría puede tener una categoría padre

---

## 📱 Adaptación a la Arquitectura

### Domain Layer
- Entidades puras sin dependencias externas
- Casos de uso que implementan la lógica de negocio
- Contratos de repositorios

### Data Layer
- Modelos que extienden las entidades
- Implementaciones de repositorios
- Fuentes de datos (API, local storage)

### Presentation Layer
- BLoC para gestión de estado
- Widgets que consumen las entidades
- Páginas que orquestan los widgets 