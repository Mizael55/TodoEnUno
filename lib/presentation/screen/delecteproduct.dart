import 'package:flutter/material.dart';
import 'package:store/models/models.dart';
import 'package:store/theme/app_colors.dart';

import '../../utils/utils.dart';

class DeleteProductScreen extends StatelessWidget {
  final Product product;

  const DeleteProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eliminar Producto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.secondary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          color: AppColors.iconPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),

        // ignore: deprecated_member_use
        shadowColor: AppColors.secondary.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          // Botón de notificaciones (opcional)
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          // Botón de carrito (opcional)
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen del producto
            Hero(
              tag: 'product-image-${product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Mensaje de confirmación
            Text(
              '¿Estás seguro de eliminar este producto?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Nombre del producto
            Text(
              product.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Detalles adicionales
            _buildDetailRow(Icons.category, product.category),
            _buildDetailRow(
              Icons.attach_money,
              '\$${product.price.toStringAsFixed(2)}',
            ),
            _buildDetailRow(
              Icons.calendar_today,
              'Agregado: ${_formatDate(product.createdAt)}',
            ),
            const SizedBox(height: 40),

            // Botones de acción
            Row(
              children: [
                // Botón Cancelar
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppColors.secondary),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'CANCELAR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.error,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => CustomAlert(
                        title: 'Confirmar Eliminación',
                        message:
                            '¿Estás seguro de que deseas eliminar este producto?',
                        buttonText: 'ELIMINAR',
                        onClose: () {
                          print('Producto eliminado: ${product.name}');
                          Navigator.of(context).pop(true);
                        },
                        type: AlertType.error,
                      ),
                    ),

                    child: const Text(
                      'ELIMINAR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
