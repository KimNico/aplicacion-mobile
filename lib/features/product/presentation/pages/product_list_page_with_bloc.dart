import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/product_card.dart';

class ProductListPageWithBloc extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListPageWithBloc({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductListPageWithBloc> createState() => _ProductListPageWithBlocState();
}

class _ProductListPageWithBlocState extends State<ProductListPageWithBloc> {
  @override
  void initState() {
    super.initState();
    // Cargar productos de la categoría al inicializar
    context.read<ProductBloc>().add(LoadProductsByCategory(
      categoryId: widget.categoryId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Todos', true),
                        _buildFilterChip('Precio: Menor', false),
                        _buildFilterChip('Precio: Mayor', false),
                        _buildFilterChip('Nombre A-Z', false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Products grid
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state is ProductsError) {
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
                          'Error al cargar productos',
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
                            context.read<ProductBloc>().add(LoadProductsByCategory(
                              categoryId: widget.categoryId,
                            ));
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () => _navigateToProductDetail(product),
                        );
                      },
                    ),
                  );
                }
                
                // Estado inicial o desconocido
                return const Center(
                  child: Text('No hay productos disponibles'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Aplicar filtro
          if (selected) {
            final filters = <String, dynamic>{};
            switch (label) {
              case 'Precio: Menor':
                filters['sort'] = 'price_asc';
                break;
              case 'Precio: Mayor':
                filters['sort'] = 'price_desc';
                break;
              case 'Nombre A-Z':
                filters['sort'] = 'name_asc';
                break;
            }
            
            context.read<ProductBloc>().add(ApplyFilters(filters));
            context.read<ProductBloc>().add(LoadProductsByCategory(
              categoryId: widget.categoryId,
              filters: filters,
            ));
          }
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[100],
        checkmarkColor: Colors.blue[600],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay productos disponibles',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otros filtros',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Price range
          const Text(
            'Rango de precio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: const RangeValues(0, 10000),
            min: 0,
            max: 10000,
            divisions: 100,
            labels: const RangeLabels('\$0', '\$10000'),
            onChanged: (values) {
              // Aplicar filtro de precio
              final filters = <String, dynamic>{
                'min_price': values.start,
                'max_price': values.end,
              };
              
              context.read<ProductBloc>().add(ApplyFilters(filters));
            },
          ),
          
          const SizedBox(height: 20),
          
          // Sort options
          const Text(
            'Ordenar por',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildSortChip('Nombre A-Z', 'name'),
              _buildSortChip('Precio: Menor', 'price_asc'),
              _buildSortChip('Precio: Mayor', 'price_desc'),
              _buildSortChip('Más recientes', 'date'),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Recargar productos con filtros
                context.read<ProductBloc>().add(LoadProductsByCategory(
                  categoryId: widget.categoryId,
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Aplicar filtros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: false,
      onSelected: (selected) {
        if (selected) {
          final filters = <String, dynamic>{
            'sort': value,
          };
          
          context.read<ProductBloc>().add(ApplyFilters(filters));
        }
      },
    );
  }

  void _navigateToProductDetail(product) {
    context.pushNamed(
      'productDetail',
      pathParameters: {'productId': product.id},
    );
  }
} 