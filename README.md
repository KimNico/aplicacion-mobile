# Mobile App - Clean Architecture

## Estructura del Proyecto

Esta aplicación móvil está construida siguiendo los principios de **Clean Architecture** con una estructura modular.

### Estructura de Carpetas

```
lib/
│
├── core/                           # Módulo compartido
│   ├── error/                      # Manejo de errores
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                    # Utilidades de red
│   │   └── network_info.dart
│   └── utils/                      # Utilidades generales
│       └── constants.dart
│
├── features/                       # Módulos de características
│   └── product/                    # Feature de productos
│       ├── data/                   # Capa de datos
│       │   ├── datasources/        # Fuentes de datos
│       │   │   ├── product_remote_data_source.dart
│       │   │   └── product_local_data_source.dart
│       │   ├── models/             # Modelos de datos
│       │   │   └── product_model.dart
│       │   └── repositories/       # Implementaciones de repositorios
│       │       └── product_repository_impl.dart
│       │
│       ├── domain/                 # Capa de dominio
│       │   ├── entities/           # Entidades del dominio
│       │   │   ├── product.dart
│       │   │   └── category.dart
│       │   ├── repositories/       # Contratos de repositorios
│       │   │   └── product_repository.dart
│       │   └── usecases/          # Casos de uso
│       │       ├── get_products_by_category.dart
│       │       ├── get_product_detail.dart
│       │       └── contact_store.dart
│       │
│       └── presentation/           # Capa de presentación
│           ├── bloc/               # Gestión de estado
│           │   ├── product_bloc.dart
│           │   ├── product_event.dart
│           │   └── product_state.dart
│           ├── pages/              # Páginas
│           │   ├── product_list_page.dart
│           │   ├── product_detail_page.dart
│           │   └── categories_page.dart
│           └── widgets/            # Widgets reutilizables
│               ├── product_card.dart
│               └── category_chip.dart
│
├── app.dart                        # Widget principal de la app
├── main.dart                       # Punto de entrada
└── injection_container.dart        # Inyección de dependencias
```

### Categorías de Productos

La aplicación maneja las siguientes categorías:
- Hombre
- Mujer
- Niños
- Accesorios de moda
- Ropa deportiva
- Blanquería
- Otros

### Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo
- **Clean Architecture**: Arquitectura del proyecto
- **BLoC**: Gestión de estado
- **GetIt**: Inyección de dependencias
- **Dio**: Cliente HTTP
- **SharedPreferences**: Almacenamiento local

### Próximos Pasos

1. Implementar las entidades del dominio
2. Crear los casos de uso
3. Implementar los repositorios
4. Desarrollar la capa de presentación
5. Configurar la inyección de dependencias 