import '../features/product/data/models/product_model.dart';
import '../features/product/data/models/store_model.dart';
import '../features/product/data/models/category_model.dart';

/// Ejemplo de uso de los modelos de datos
class ModelUsageExample {
  
  /// Ejemplo de creación de un producto desde JSON
  static ProductModel createProductFromJson() {
    final json = {
      'id': 'prod_001',
      'name': 'Remera de Algodón',
      'description': 'Remera 100% algodón, cómoda y transpirable',
      'price': 2500.0,
      'category_id': 'cat_ropa_hombre',
      'store_id': 'store_001',
      'images': [
        'https://example.com/remera1.jpg',
        'https://example.com/remera2.jpg'
      ],
      'is_available': true,
      'stock_quantity': 15,
      'created_at': '2024-01-15T10:30:00Z',
      'updated_at': '2024-01-15T10:30:00Z',
      'tags': ['algodón', 'básica', 'hombre'],
      'specifications': {
        'material': 'Algodón 100%',
        'talla': 'M',
        'color': 'Blanco'
      }
    };

    return ProductModel.fromJson(json);
  }

  /// Ejemplo de creación de un local desde JSON
  static StoreModel createStoreFromJson() {
    final json = {
      'id': 'store_001',
      'name': 'Ropa Avellaneda',
      'description': 'Local de ropa en el centro de Avellaneda',
      'address': 'Av. Mitre 123, Avellaneda',
      'phone': '+54 11 1234-5678',
      'email': 'info@ropaavellaneda.com',
      'whatsapp': '+54 11 9876-5432',
      'website': 'https://ropaavellaneda.com',
      'latitude': -34.6617,
      'longitude': -58.3647,
      'images': [
        'https://example.com/store1.jpg',
        'https://example.com/store2.jpg'
      ],
      'hours': {
        'schedules': {
          'monday': {
            'is_open': true,
            'open_time': '09:00',
            'close_time': '18:00',
            'break_start': '12:00',
            'break_end': '13:00'
          },
          'tuesday': {
            'is_open': true,
            'open_time': '09:00',
            'close_time': '18:00',
            'break_start': '12:00',
            'break_end': '13:00'
          },
          'wednesday': {
            'is_open': true,
            'open_time': '09:00',
            'close_time': '18:00',
            'break_start': '12:00',
            'break_end': '13:00'
          },
          'thursday': {
            'is_open': true,
            'open_time': '09:00',
            'close_time': '18:00',
            'break_start': '12:00',
            'break_end': '13:00'
          },
          'friday': {
            'is_open': true,
            'open_time': '09:00',
            'close_time': '18:00',
            'break_start': '12:00',
            'break_end': '13:00'
          },
          'saturday': {
            'is_open': true,
            'open_time': '09:00',
            'close_time': '13:00',
            'break_start': null,
            'break_end': null
          },
          'sunday': {
            'is_open': false,
            'open_time': '',
            'close_time': '',
            'break_start': null,
            'break_end': null
          }
        },
        'special_hours': 'Cerrado en días feriados',
        'is_open_now': true
      },
      'is_active': true,
      'categories': ['cat_ropa_hombre', 'cat_ropa_mujer'],
      'created_at': '2024-01-01T00:00:00Z',
      'updated_at': '2024-01-15T10:30:00Z'
    };

    return StoreModel.fromJson(json);
  }

  /// Ejemplo de creación de una categoría desde JSON
  static CategoryModel createCategoryFromJson() {
    final json = {
      'id': 'cat_ropa_hombre',
      'name': 'Ropa de Hombre',
      'description': 'Todo tipo de ropa para hombres',
      'parent_id': null,
      'icon': 'assets/icons/men_clothing.png',
      'product_count': 150,
      'is_active': true,
      'sort_order': 1
    };

    return CategoryModel.fromJson(json);
  }

  /// Ejemplo de conversión a JSON
  static Map<String, dynamic> convertProductToJson() {
    final product = createProductFromJson();
    return product.toJson();
  }

  /// Ejemplo de conversión de lista a JSON
  static List<Map<String, dynamic>> convertProductListToJson() {
    final products = [
      createProductFromJson(),
      createProductFromJson().copyWith(
        id: 'prod_002',
        name: 'Pantalón Jean',
        price: 3500.0,
      ),
    ];

    return ProductModel.toJsonList(products);
  }

  /// Ejemplo de uso con API
  static void apiUsageExample() {
    // Simulación de respuesta de API
    final apiResponse = {
      'products': [
        {
          'id': 'prod_001',
          'name': 'Remera de Algodón',
          'description': 'Remera 100% algodón',
          'price': 2500.0,
          'category_id': 'cat_ropa_hombre',
          'store_id': 'store_001',
          'images': ['https://example.com/remera1.jpg'],
          'is_available': true,
          'stock_quantity': 15,
          'created_at': '2024-01-15T10:30:00Z',
          'updated_at': '2024-01-15T10:30:00Z',
          'tags': ['algodón', 'básica'],
          'specifications': {}
        }
      ],
      'total': 1,
      'page': 1,
      'limit': 10
    };

    // Parsear productos desde la respuesta de la API
    final productsJson = apiResponse['products'] as List<dynamic>;
    final products = ProductModel.fromJsonList(productsJson);

    // Usar los productos parseados
    for (final product in products) {
      print('Producto: ${product.name} - Precio: \$${product.price}');
    }
  }
} 