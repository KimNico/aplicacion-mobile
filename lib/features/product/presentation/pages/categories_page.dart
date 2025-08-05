import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/category_card.dart';
import '../../data/models/category_model.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Proyecto',
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _getCategories().length,
                      itemBuilder: (context, index) {
                        final category = _getCategories()[index];
                        return CategoryCard(
                          category: category,
                          onTap: () => _navigateToProducts(context, category),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<CategoryModel> _getCategories() {
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

  void _navigateToProducts(BuildContext context, CategoryModel category) {
    context.pushNamed(
      'productList',
      pathParameters: {'categoryId': category.id},
      queryParameters: {'name': category.name},
    );
  }
} 