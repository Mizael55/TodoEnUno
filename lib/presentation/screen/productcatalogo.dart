import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/presentation/produc/bloc/product_bloc.dart';
import 'package:store/theme/app_colors.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ProductCatalogScreen extends StatelessWidget {
  const ProductCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(const LoadProducts());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Productos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.secondary,
        // ignore: deprecated_member_use
        shadowColor: AppColors.secondary.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            color: Colors.white,
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  products:
                      context.read<ProductBloc>().state is ProductLoadSuccess
                      ? (context.read<ProductBloc>().state
                                as ProductLoadSuccess)
                            .products
                      : [],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          // const Padding(
          //   padding: EdgeInsets.only(right: 12),
          //   child: CartIconWithBadge(),
          // ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoadSuccess) {
            return _buildProductList(state.products);
          } else if (state is ProductFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: Text('No hay productos disponibles'));
        },
      ),
      floatingActionButton: CustomFloatingActionButton(context: context),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.61, // Proporción ajustada para evitar overflow
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: ProductSearchDelegate(
        products: context.read<ProductBloc>().state is ProductLoadSuccess
            ? (context.read<ProductBloc>().state as ProductLoadSuccess).products
            : [],
      ),
    );
  }
}
