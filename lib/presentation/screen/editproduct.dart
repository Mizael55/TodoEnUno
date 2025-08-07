import 'package:flutter/material.dart';
import 'package:store/models/models.dart';
import 'package:store/theme/app_colors.dart';

import '../../utils/utils.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _categoryController = TextEditingController(text: widget.product.category);
    _descriptionController = TextEditingController(
      text: widget.product.description ?? '',
    );
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Producto',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview de la imagen
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Hero(
                    tag: 'product-image-${widget.product.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _imageUrlController.text.isNotEmpty
                          ? Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            )
                          : const Icon(Icons.image, size: 50),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo URL de la imagen
              CustomTextInput(
                controller: _imageUrlController,
                label: 'URL de la imagen',
                prefixIcon: Icons.link,
                inputType: CustomInputType.text,
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 20),

              // Campo Nombre
              CustomTextInput(
                controller: _nameController,
                label: 'Nombre del producto',
                prefixIcon: Icons.shopping_bag,
              ),
              const SizedBox(height: 20),

              // Campo Precio
              CustomTextInput(
                controller: _priceController,
                label: 'Precio',
                prefixIcon: Icons.attach_money,
                inputType: CustomInputType.number,
              ),
              const SizedBox(height: 20),

              // Campo Categoría
              CustomTextInput(
                controller: _categoryController,
                label: 'Categoría',
                prefixIcon: Icons.category,
              ),
              const SizedBox(height: 20),

              // Campo Descripción
              CustomTextInput(
                controller: _descriptionController,
                label: 'Descripción (opcional)',
                prefixIcon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // Botones de acción
              Row(
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.error),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Botón Guardar
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.secondary),
                      ),
                      onPressed: _saveChanges,
                      child: const Text(
                        'GUARDAR CAMBIOS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final editedProduct = Product(
        id: widget.product.id,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        category: _categoryController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        createdAt: widget.product.createdAt,
      );

      Navigator.of(context).pop(editedProduct);
    }
  }
}
