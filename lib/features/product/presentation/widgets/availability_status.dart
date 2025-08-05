import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class AvailabilityStatusWidget extends StatelessWidget {
  final ProductModel product;
  const AvailabilityStatusWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    if (!product.isAvailable) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Agotado',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (product.stockQuantity <= 5) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Solo quedan 20{product.stockQuantity} unidades',
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Disponible',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 