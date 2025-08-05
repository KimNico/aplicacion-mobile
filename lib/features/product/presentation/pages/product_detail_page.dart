import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/product_model.dart';
import '../../data/models/store_model.dart';
import '../widgets/image_gallery.dart';
import '../widgets/availability_status.dart';
import '../widgets/store_info.dart';
import '../widgets/contact_buttons.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductModel? _product;
  StoreModel? _store;
  bool _isLoading = true;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  void _loadProductDetails() {
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _product = _getMockProduct();
        _store = _getMockStore();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text('Producto no encontrado'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image gallery
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: ImageGalleryWidget(
                images: _product!.images,
                currentIndex: _currentImageIndex,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // Add to favorites
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Share product
                },
              ),
            ],
          ),
          // Product details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name and price
                  Text(
                    _product!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ' 4${_product!.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Availability status
                  AvailabilityStatusWidget(product: _product!),
                  const SizedBox(height: 20),
                  // Description
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _product!.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Store information
                  if (_store != null) StoreInfoWidget(store: _store),
                  const SizedBox(height: 30),
                  // Contact buttons
                  ContactButtonsWidget(store: _store, product: _product),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ProductModel _getMockProduct() {
    return const ProductModel(
      id: 'prod_001',
      name: 'Remera de Algodón Premium',
      description: 'Remera 100% algodón de alta calidad, cómoda y transpirable. Perfecta para el día a día, con un corte moderno y un ajuste ideal. Disponible en varios colores y talles.',
      price: 2500.0,
      categoryId: 'cat_ropa_hombre',
      storeId: 'store_001',
      images: [
        'https://picsum.photos/400/500?random=1',
        'https://picsum.photos/400/500?random=2',
        'https://picsum.photos/400/500?random=3',
      ],
      isAvailable: true,
      stockQuantity: 15,
      createdAt: null,
      updatedAt: null,
    );
  }

  StoreModel _getMockStore() {
    return const StoreModel(
      id: 'store_001',
      name: 'Ropa Avellaneda',
      description: 'Local de ropa en el centro de Avellaneda',
      address: 'Av. Mitre 123, Avellaneda, Buenos Aires',
      phone: '+54 11 1234-5678',
      email: 'info@ropaavellaneda.com',
      whatsapp: '+54 11 9876-5432',
      website: 'https://ropaavellaneda.com',
      latitude: -34.6617,
      longitude: -58.3647,
      images: [],
      hours: null,
      createdAt: null,
      updatedAt: null,
    );
  }
} 