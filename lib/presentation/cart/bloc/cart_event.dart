part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

/// Evento para agregar un producto al carrito
class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  const AddToCartEvent({
    required this.product,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [product, quantity];
}

/// Evento para remover un producto del carrito
class RemoveFromCartEvent extends CartEvent {
  final String cartItemId;  // Cambiar nombre del parámetro

  const RemoveFromCartEvent(this.cartItemId);
}

/// Evento para actualizar la cantidad de un producto en el carrito
class UpdateCartItemQuantityEvent extends CartEvent {
  final String cartItemId;  // Cambiar nombre del parámetro
  final int newQuantity;

  const UpdateCartItemQuantityEvent({
    required this.cartItemId,
    required this.newQuantity,
  });
}

/// Evento para cargar el carrito desde el repositorio
class LoadCartEvent extends CartEvent {}

/// Evento para vaciar completamente el carrito
class ClearCartEvent extends CartEvent {}

class AuthChangedEvent extends CartEvent {
  final User? user;

  const AuthChangedEvent({required this.user});

  @override
  List<Object> get props => [user ?? Object()];
}