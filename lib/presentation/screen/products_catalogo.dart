import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/constants/categories.dart';
import 'package:store/presentation/auth/bloc/auth_bloc.dart';
import 'package:store/presentation/produc/bloc/product_bloc.dart';
import 'package:store/theme/app_colors.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: productCategories.length + 1, // +1 para "Todos"
      vsync: this,
    );
    context.read<ProductBloc>().add(const LoadProducts());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.search, size: 28),
          color: AppColors.iconPrimary,
          onPressed: () {
            final state = context.read<ProductBloc>().state;
            final products = state is ProductLoadSuccess ? state.products : [];
            showSearch(
              context: context,
              delegate: ProductSearchDelegate(
                products: products.cast<Product>(),
              ),
            );
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // TabBar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              color: AppColors.secondary,
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                const Tab(
                  text: 'Todos',
                  icon: Icon(Icons.all_inclusive, size: 20),
                ),
                ...productCategories.map(
                  (category) => Tab(
                    text: category.label,
                    icon: Icon(category.icon, size: 20),
                  ),
                ),
              ],
            ),
          ),
          // Contenido de los tabs
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                // Contenido principal basado en el estado
                Widget content;

                if (state is ProductLoadSuccess) {
                  content = TabBarView(
                    controller: _tabController,
                    children: [
                      _buildProductList(state.products),
                      ...productCategories.map((category) {
                        final filteredProducts = state.products
                            .where((p) => p.category == category.value)
                            .toList();
                        return _buildProductList(filteredProducts);
                      }),
                    ],
                  );
                } else if (state is ProductFailure) {
                  content = Center(child: Text('Error: ${state.error}'));
                } else {
                  content = const Center(
                    child: Text('No hay productos disponibles'),
                  );
                }

                // Mostrar el indicador de carga encima si está cargando
                return Stack(
                  children: [
                    content,
                    if (state is ProductLoading)
                      const Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.indigo,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.secondary,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomFloatingActionButton(
            context: context,
            label: 'Agregar Producto',
            backgroundColor: AppColors.secondary,
          ),
          const SizedBox(height: 16),
          CustomFloatingActionButton(
            context: context,
            label: 'Cerrar sesión',
            onPressedCallback: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
            backgroundColor: AppColors.error,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return products.isEmpty
        ? const Center(
            child: Text(
              'No hay productos en esta categoría',
              style: TextStyle(fontSize: 16),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.61,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                ProductCard(product: products[index]),
          );
  }
}
