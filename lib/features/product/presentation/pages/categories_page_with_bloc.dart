import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/category_card.dart';
import '../../data/models/category_model.dart';

class CategoriesPageWithBloc extends StatefulWidget {
  const CategoriesPageWithBloc({super.key});

  @override
  State<CategoriesPageWithBloc> createState() => _CategoriesPageWithBlocState();
}

class _CategoriesPageWithBlocState extends State<CategoriesPageWithBloc> {
  @override
  void initState() {
    super.initState();
    // Cargar categorías al inicializar
    context.read<ProductBloc>().add(const LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Avellaneda a un Toque',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[600]!,
              Colors.blue[400]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      '¿Qué estás buscando?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explora nuestras categorías',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Categories grid
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is CategoriesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      
                      if (state is CategoriesError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error al cargar categorías',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.message,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
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
                      
                      if (state is CategoriesLoaded) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.1,
                            ),
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              final category = state.categories[index];
                              return CategoryCard(
                                category: category,
                                onTap: () => _navigateToProducts(context, category),
                              );
                            },
                          ),
                        );
                      }
                      
                      // Estado inicial o desconocido
                      return const Center(
                        child: Text('No hay categorías disponibles'),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProducts(BuildContext context, CategoryModel category) {
    // Seleccionar la categoría en el Bloc
    context.read<ProductBloc>().add(SelectCategory(category));
    
    // Navegar a la pantalla de productos
    context.pushNamed(
      'productList',
      pathParameters: {'categoryId': category.id},
      queryParameters: {'name': category.name},
    );
  }
} 