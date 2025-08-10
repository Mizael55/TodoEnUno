import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/constants/categories.dart';
import 'package:store/presentation/auth/bloc/auth_bloc.dart';
import 'package:store/presentation/cart/bloc/cart_bloc.dart';
import 'package:store/presentation/produc/bloc/product_bloc.dart';
import 'package:store/theme/app_colors.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'screen.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _userType; // Almacenaremos solo el userType
  // bool _isLoadingUser = true;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: productCategories.length + 1, // +1 para "Todos"
      vsync: this,
    );
    context.read<ProductBloc>().add(const LoadProducts());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            _userType =
                doc.get('userType') as String?; // Extraemos solo userType
            // _isLoadingUser = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      // setState(() => _isLoadingUser = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('User Type: $_userType'); // Para depuración
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
          if (_userType !=
              'seller') // Solo mostrar si el usuario no es vendedor
            BlocListener<CartBloc, CartState>(
              listener: (context, state) {
                print('[LISTENER] Estado cambiado: ${state.runtimeType}');
              },
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  final itemCount = state is CartLoaded
                      ? state.items.fold(
                          0,
                          (sum, item) => sum + (item.quantity),
                        )
                      : 0;

                  print('[BUILDER] Construyendo con itemCount: $itemCount');

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },
                      ),
                      if (state is CartLoaded) ...[
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${state.items.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
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
                      _buildProductList(state.products, _userType),
                      ...productCategories.map((category) {
                        final filteredProducts = state.products
                            .where((p) => p.category == category.value)
                            .toList();
                        return _buildProductList(filteredProducts, _userType);
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
          if (_userType == 'seller') // Solo mostrar si el usuario es vendedor
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
              // Navegar a la pantalla de inicio de sesión
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthWrapper()),
              );
            },
            backgroundColor: AppColors.error,
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products, userType) {
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
              childAspectRatio: 0.58,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                ProductCard(product: products[index], userType: userType),
          );
  }
}
