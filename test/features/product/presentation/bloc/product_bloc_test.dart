import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import '../../../../lib/features/product/presentation/bloc/product_bloc_with_api.dart';
import '../../../../lib/features/product/presentation/bloc/product_event.dart';
import '../../../../lib/features/product/presentation/bloc/product_state.dart';
import '../../../../lib/features/product/data/models/category_model.dart';
import '../../../../lib/features/product/data/models/product_model.dart';
import '../../../../lib/features/product/data/models/store_model.dart';
import '../../../../lib/core/error/failures.dart';
import '../../../mocks/mock_product_repository.dart';

void main() {
  EquatableConfig.stringify = true;
  late MockProductRepository mockRepository;
  late ProductBlocWithApi bloc;

  setUp(() {
    mockRepository = MockProductRepository();
    bloc = ProductBlocWithApi(productRepository: mockRepository);
  });

  group('Fetch Categorías', () {
    final categories = [
      CategoryModel(
        id: 'cat_1',
        name: 'Hombre',
        description: 'Ropa para hombre',
        icon: null,
        productCount: 10,
        sortOrder: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    test('emite [CategoriesLoading, CategoriesLoaded] en fetch exitoso', () async {
      when(mockRepository.getCategories())
          .thenAnswer((_) async => Right(categories));

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CategoriesLoading>(),
          predicate<CategoriesLoaded>((state) => state.categories == categories),
        ]),
      );

      bloc.add(const LoadCategories());
    });

    test('emite [CategoriesLoading, CategoriesError] en error de red', () async {
      when(mockRepository.getCategories())
          .thenAnswer((_) async => Left(NetworkFailure('No hay conexión')));

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CategoriesLoading>(),
          isA<CategoriesError>(),
        ]),
      );

      bloc.add(const LoadCategories());
    });
  });

  group('Fetch Productos por Categoría', () {
    final products = [
      ProductModel(
        id: 'prod_1',
        name: 'Remera',
        description: 'Remera algodón',
        price: 1000,
        categoryId: 'cat_1',
        storeId: 'store_1',
        images: ['img1'],
        isAvailable: true,
        stockQuantity: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    test('emite [ProductsLoading, ProductsLoaded] en fetch exitoso', () async {
      when(mockRepository.getProductsByCategory('cat_1', filters: null))
          .thenAnswer((_) async => Right(products));

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProductsLoading>(),
          predicate<ProductsLoaded>((state) => state.products == products),
        ]),
      );

      bloc.add(const LoadProductsByCategory(categoryId: 'cat_1'));
    });

    test('emite [ProductsLoading, ProductsError] en error de red', () async {
      when(mockRepository.getProductsByCategory('cat_1', filters: null))
          .thenAnswer((_) async => Left(NetworkFailure('No hay conexión')));

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProductsLoading>(),
          isA<ProductsError>(),
        ]),
      );

      bloc.add(const LoadProductsByCategory(categoryId: 'cat_1'));
    });
  });

  group('Contacto desde Detalle', () {
    final product = ProductModel(
      id: 'prod_1',
      name: 'Remera',
      description: 'Remera algodón',
      price: 1000,
      categoryId: 'cat_1',
      storeId: 'store_1',
      images: ['img1'],
      isAvailable: true,
      stockQuantity: 5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final store = StoreModel(
      id: 'store_1',
      name: 'Tienda',
      description: 'Tienda de ropa',
      address: 'Calle 123',
      phone: '+123456789',
      email: 'tienda@mail.com',
      whatsapp: '+123456789',
      website: 'https://tienda.com',
      latitude: 0.0,
      longitude: 0.0,
      images: [],
      hours: StoreHours(schedules: {}, specialHours: '', isOpenNow: true),
      isActive: true,
      categories: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('emite [ContactLoading, ContactSuccess] al contactar por teléfono', () async {
      when(mockRepository.getStoreById('store_1'))
          .thenAnswer((_) async => Right(store));

      // Simular éxito en _makePhoneCall
      final blocWithPhoneCall = ProductBlocWithApi(productRepository: mockRepository);
      blocWithPhoneCall._makePhoneCall = (_) async => true;

      expectLater(
        blocWithPhoneCall.stream,
        emitsInOrder([
          isA<ContactLoading>(),
          isA<ContactSuccess>(),
        ]),
      );

      blocWithPhoneCall.add(ContactStore(storeId: 'store_1', method: ContactMethod.phone, product: product));
    });

    test('emite [ContactLoading, ContactError] si falla la obtención del local', () async {
      when(mockRepository.getStoreById('store_1'))
          .thenAnswer((_) async => Left(ServerFailure('No encontrado')));

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ContactLoading>(),
          isA<ContactError>(),
        ]),
      );

      bloc.add(ContactStore(storeId: 'store_1', method: ContactMethod.phone, product: product));
    });
  });
} 