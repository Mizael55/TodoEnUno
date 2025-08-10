// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/presentation/cart/bloc/repository/cart_repository.dart';
import 'package:store/theme/app_colors.dart';
import '../../models/models.dart';
import '../cart/bloc/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CartBloc(cartRepository: context.read<CartRepository>())
            ..add(LoadCartEvent()),
      child: Scaffold(
        backgroundColor: AppColors.cardBackground,
        appBar: _buildAppBar(context),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          buildWhen: (previous, current) {
            // Solo reconstruir si cambia el tipo de estado o el número de items
            if (current is CartLoaded && previous is CartLoaded) {
              return current.items.length != previous.items.length;
            }
            return true;
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.secondary,
              ));
            }

            final cartItems = state is CartLoaded ? state.items : [];

            return Column(
              children: [
                // Lista de productos
                Expanded(
                  child: _buildProductList(context, cartItems.cast<CartItem>()),
                ),

                // Resumen del pedido
                if (cartItems.isNotEmpty)
                  _buildOrderSummary(
                    context,
                    state is CartLoaded ? state.total : 0,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Mi Carrito',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.secondary,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        BlocBuilder<CartBloc, CartState>(
          buildWhen: (previous, current) {
            return current is! CartLoading && previous is! CartLoading;
          },
          builder: (context, state) {
            final hasItems = state is CartLoaded && state.items.isNotEmpty;
            return hasItems
                ? IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () =>
                        context.read<CartBloc>().add(ClearCartEvent()),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildProductList(BuildContext context, List<CartItem> cartItems) {
    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Tu carrito está vacío',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega productos para continuar',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Explorar productos',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      physics: const BouncingScrollPhysics(),
      itemCount: cartItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final cartItem = cartItems[index];
        return _CartItemWidget(
          key: ValueKey(cartItem.id),
          cartItem: cartItem,
          onDecrement: () {
            if (cartItem.quantity > 1) {
              context.read<CartBloc>().add(
                UpdateCartItemQuantityEvent(
                  cartItemId: cartItem.id,
                  newQuantity: cartItem.quantity - 1,
                ),
              );
            }
          },
          onIncrement: () {
            context.read<CartBloc>().add(
              UpdateCartItemQuantityEvent(
                cartItemId: cartItem.id,
                newQuantity: cartItem.quantity + 1,
              ),
            );
          },
          onRemove: () {
            context.read<CartBloc>().add(
              RemoveFromCartEvent(cartItem.id),
            );
          },
        );
      },
    );
  }

  Widget _buildOrderSummary(BuildContext context, double total) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) {
        if (current is CartLoaded && previous is CartLoaded) {
          return current.total != previous.total;
        }
        return true;
      },
      builder: (context, state) {
        final displayTotal = state is CartLoaded ? state.total : total;
        
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSummaryRow('Subtotal', '\$${displayTotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildSummaryRow('Envío', 'Gratis'),
              const SizedBox(height: 8),
              _buildSummaryRow('Descuento', '-\$0.00'),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 16),
              _buildSummaryRow(
                'Total',
                '\$${displayTotal.toStringAsFixed(2)}',
                isTotal: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Procesando pago...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'PAGAR AHORA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.textPrimary.withOpacity(isTotal ? 1 : 0.7),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isTotal ? AppColors.secondary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onRemove;

  const _CartItemWidget({
    required Key key,
    required this.cartItem,
    required this.onDecrement,
    required this.onIncrement,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(14),
            ),
            child: SizedBox(
              width: 100,
              height: 100,
              child: CachedNetworkImage(
                imageUrl: cartItem.product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cartItem.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: onRemove,
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: AppColors.error,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cartItem.product.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: cartItem.quantity > 1 ? onDecrement : null,
                              icon: const Icon(Icons.remove_rounded, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: cartItem.quantity > 1
                                  ? AppColors.secondary
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${cartItem.quantity}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: onIncrement,
                              icon: const Icon(Icons.add_rounded, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}