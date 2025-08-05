# Modelos de Datos - Proyecto

## 📋 Resumen

Se han creado los modelos de datos principales para la aplicación siguiendo Clean Architecture:

- **Product**: Producto con información completa
- **Store**: Local comercial con datos de contacto y horarios
- **Category**: Categoría de productos con jerarquía

## 🏗️ Estructura de Modelos

### 1. Product (Producto)

**Campos principales:**
- `id`: Identificador único
- `name`: Nombre del producto
- `description`: Descripción detallada
- `price`: Precio en pesos argentinos
- `categoryId`: ID de la categoría
- `storeId`: ID del local
- `images`: Lista de URLs de imágenes
- `isAvailable`: Disponibilidad
- `stockQuantity`: Cantidad en stock
- `tags`: Etiquetas para búsqueda
- `specifications`: Especificaciones técnicas

**Serialización JSON:**
```json
{
  "id": "prod_001",
  "name": "Remera de Algodón",
  "description": "Remera 100% algodón, cómoda y transpirable",
  "price": 2500.0,
  "category_id": "cat_ropa_hombre",
  "store_id": "store_001",
  "images": ["https://example.com/remera1.jpg"],
  "is_available": true,
  "stock_quantity": 15,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "tags": ["algodón", "básica", "hombre"],
  "specifications": {
    "material": "Algodón 100%",
    "talla": "M",
    "color": "Blanco"
  }
}
```

### 2. Store (Local)

**Campos principales:**
- `id`: Identificador único
- `name`: Nombre del local
- `description`: Descripción del local
- `address`: Dirección física
- `phone`: Teléfono de contacto
- `email`: Email de contacto
- `whatsapp`: Número de WhatsApp
- `website`: Sitio web
- `latitude/longitude`: Coordenadas GPS
- `images`: Fotos del local
- `hours`: Horarios de atención
- `categories`: Categorías que maneja

**Serialización JSON:**
```json
{
  "id": "store_001",
  "name": "Ropa Avellaneda",
  "description": "Local de ropa en el centro de Avellaneda",
  "address": "Av. Mitre 123, Avellaneda",
  "phone": "+54 11 1234-5678",
  "email": "info@ropaavellaneda.com",
  "whatsapp": "+54 11 9876-5432",
  "website": "https://ropaavellaneda.com",
  "latitude": -34.6617,
  "longitude": -58.3647,
  "images": ["https://example.com/store1.jpg"],
  "hours": {
    "schedules": {
      "monday": {
        "is_open": true,
        "open_time": "09:00",
        "close_time": "18:00",
        "break_start": "12:00",
        "break_end": "13:00"
      }
    },
    "special_hours": "Cerrado en días feriados",
    "is_open_now": true
  },
  "is_active": true,
  "categories": ["cat_ropa_hombre", "cat_ropa_mujer"],
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

### 3. Category (Categoría)

**Campos principales:**
- `id`: Identificador único
- `name`: Nombre de la categoría
- `description`: Descripción
- `parentId`: ID de categoría padre (para jerarquías)
- `icon`: Icono de la categoría
- `productCount`: Cantidad de productos
- `isActive`: Si está activa
- `sortOrder`: Orden de visualización

**Serialización JSON:**
```json
{
  "id": "cat_ropa_hombre",
  "name": "Ropa de Hombre",
  "description": "Todo tipo de ropa para hombres",
  "parent_id": null,
  "icon": "assets/icons/men_clothing.png",
  "product_count": 150,
  "is_active": true,
  "sort_order": 1
}
```

## 🔄 Funcionalidades de Serialización

### Métodos Disponibles

**ProductModel:**
- `fromJson(Map<String, dynamic>)`: Crear desde JSON
- `toJson()`: Convertir a JSON
- `fromJsonList(List<dynamic>)`: Crear lista desde JSON
- `toJsonList(List<ProductModel>)`: Convertir lista a JSON
- `copyWith()`: Crear copia modificada

**StoreModel:**
- `fromJson(Map<String, dynamic>)`: Crear desde JSON
- `toJson()`: Convertir a JSON
- `fromJsonList(List<dynamic>)`: Crear lista desde JSON
- `toJsonList(List<StoreModel>)`: Convertir lista a JSON
- `copyWith()`: Crear copia modificada

**CategoryModel:**
- `fromJson(Map<String, dynamic>)`: Crear desde JSON
- `toJson()`: Convertir a JSON
- `fromJsonList(List<dynamic>)`: Crear lista desde JSON
- `toJsonList(List<CategoryModel>)`: Convertir lista a JSON
- `copyWith()`: Crear copia modificada

## 📱 Uso en la Aplicación

### Ejemplo de API Response
```dart
// Respuesta de API
final apiResponse = {
  'products': [
    {
      'id': 'prod_001',
      'name': 'Remera de Algodón',
      'price': 2500.0,
      // ... otros campos
    }
  ]
};

// Parsear productos
final productsJson = apiResponse['products'] as List<dynamic>;
final products = ProductModel.fromJsonList(productsJson);

// Usar en la UI
for (final product in products) {
  print('${product.name}: \$${product.price}');
}
```

### Ejemplo de Envío a API
```dart
// Crear producto
final product = ProductModel(
  id: 'prod_001',
  name: 'Remera de Algodón',
  price: 2500.0,
  // ... otros campos
);

// Convertir a JSON para enviar
final json = product.toJson();
// Enviar a API...
```

## 🏗️ Arquitectura Clean

### Domain Layer (Entidades)
- `Product`: Entidad pura del dominio
- `Store`: Entidad pura del dominio
- `Category`: Entidad pura del dominio

### Data Layer (Modelos)
- `ProductModel`: Extiende Product con serialización
- `StoreModel`: Extiende Store con serialización
- `CategoryModel`: Extiende Category con serialización

### Características
- ✅ **Inmutabilidad**: Todos los campos son final
- ✅ **Equatable**: Comparación de igualdad automática
- ✅ **copyWith**: Creación de copias modificadas
- ✅ **Serialización JSON**: Para APIs
- ✅ **Validación**: Manejo de campos opcionales
- ✅ **Tipado Fuerte**: Type safety completo

## 🔧 Dependencias

Agregadas al `pubspec.yaml`:
```yaml
dependencies:
  equatable: ^2.0.5  # Para comparación de igualdad
```

## 📝 Notas de Implementación

1. **Nomenclatura JSON**: Se usa snake_case para compatibilidad con APIs
2. **Campos Opcionales**: Se manejan con valores por defecto
3. **Fechas**: Se serializan en formato ISO 8601
4. **Listas**: Se convierten automáticamente entre tipos
5. **Maps**: Se manejan como Map<String, dynamic>

## 🚀 Próximos Pasos

1. Implementar repositorios que usen estos modelos
2. Crear casos de uso que trabajen con las entidades
3. Desarrollar la capa de presentación
4. Configurar inyección de dependencias 