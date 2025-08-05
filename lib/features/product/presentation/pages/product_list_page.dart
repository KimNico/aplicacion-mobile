import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/product_card.dart';
import '../../data/models/product_model.dart';

class ProductListPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String _sortBy = 'name';
  RangeValues _priceRange = const RangeValues(0, 10000);

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _products = _getMockProducts();
        _isLoading = false;
      });
    });
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? _buildEmptyState()
                    : _buildProductsGrid(),
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
          // Handle filter selection
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

  Widget _buildProductsGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ProductCard(
            product: product,
            onTap: () => _navigateToProductDetail(product),
          );
        },
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
            values: _priceRange,
            min: 0,
            max: 10000,
            divisions: 100,
            labels: RangeLabels(
              '\$${_priceRange.start.round()}',
              '\$${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
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
                _applyFilters();
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
      selected: _sortBy == value,
      onSelected: (selected) {
        setState(() {
          _sortBy = value;
        });
      },
    );
  }

  void _applyFilters() {
    // Apply filters logic
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call with filters
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _products = _getMockProducts().where((product) {
          return product.price >= _priceRange.start && 
                 product.price <= _priceRange.end;
        }).toList();
        _isLoading = false;
      });
    });
  }

  void _navigateToProductDetail(ProductModel product) {
    context.pushNamed(
      'productDetail',
      pathParameters: {'productId': product.id},
    );
  }

  List<ProductModel> _getMockProducts() {
    return [
      const ProductModel(
        id: 'prod_001',
        name: 'Remera de Algodón',
        description: 'Remera 100% algodón, cómoda y transpirable',
        price: 2500.0,
        categoryId: 'cat_ropa_hombre',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=1',
          'https://picsum.photos/300/400?random=2',
        ],
        isAvailable: true,
        stockQuantity: 15,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_002',
        name: 'Pantalón Jean',
        description: 'Pantalón jean clásico, perfecto para cualquier ocasión',
        price: 3500.0,
        categoryId: 'cat_ropa_hombre',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=3',
        ],
        isAvailable: true,
        stockQuantity: 8,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_003',
        name: 'Camisa Formal',
        description: 'Camisa elegante para eventos especiales',
        price: 4200.0,
        categoryId: 'cat_ropa_hombre',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=4',
        ],
        isAvailable: true,
        stockQuantity: 12,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_004',
        name: 'Buzo con Capucha',
        description: 'Buzo cómodo para el día a día',
        price: 3800.0,
        categoryId: 'cat_ropa_hombre',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=5',
        ],
        isAvailable: true,
        stockQuantity: 20,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_005',
        name: 'Zapatillas Deportivas',
        description: 'Zapatillas ideales para deporte y casual',
        price: 5500.0,
        categoryId: 'cat_ropa_hombre',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=6',
        ],
        isAvailable: true,
        stockQuantity: 6,
        createdAt: null,
        updatedAt: null,
      ),
      const ProductModel(
        id: 'prod_006',
        name: 'Cinturón de Cuero',
        description: 'Cinturón elegante de cuero genuino',
        price: 1800.0,
        categoryId: 'cat_accesorios',
        storeId: 'store_001',
        images: [
          'https://picsum.photos/300/400?random=7',
        ],
        isAvailable: true,
        stockQuantity: 25,
        createdAt: null,
        updatedAt: null,
      ),
    ];
  }
} 