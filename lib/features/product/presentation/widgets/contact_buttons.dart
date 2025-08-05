import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/models/store_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButtonsWidget extends StatelessWidget {
  final StoreModel? store;
  final ProductModel? product;
  const ContactButtonsWidget({super.key, required this.store, required this.product});

  void _makePhoneCall(BuildContext context) async {
    final phoneNumber = store?.phone ?? '+54 11 1234-5678';
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _openWhatsApp(BuildContext context) async {
    final phoneNumber = store?.whatsapp ?? '+54 11 9876-5432';
    final message = 'Hola! Me interesa el producto: ${product?.name ?? 'Producto'}';
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _sendEmail(BuildContext context) async {
    final email = store?.email ?? 'info@ropaavellaneda.com';
    final subject = 'Consulta sobre: ${product?.name ?? 'Producto'}';
    final body = 'Hola! Me interesa el producto: ${product?.name ?? 'Producto'}\n\nPrecio: \$${product?.price ?? 0}\n\nSaludos!';
    final url = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Call button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _makePhoneCall(context),
            icon: const Icon(Icons.phone),
            label: const Text(
              'Llamar al local',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // WhatsApp button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _openWhatsApp(context),
            icon: const Icon(Icons.whatsapp),
            label: const Text(
              'Consultar por WhatsApp',
              style: TextStyle(fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Email button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _sendEmail(context),
            icon: const Icon(Icons.email),
            label: const Text(
              'Enviar email',
              style: TextStyle(fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 