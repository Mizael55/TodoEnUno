import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/presentation/cart/bloc/repository/cart_repository.dart';
import '../../../models/models.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  StreamSubscription<User?>? _authSubscription;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    // Escuchar cambios de autenticación
    _listenToAuthChanges();

    // Mapeo de eventos
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartItemQuantityEvent>(_onUpdateQuantity);
    on<LoadCartEvent>(_onLoadCart);
    on<ClearCartEvent>(_onClearCart);
    on<AuthChangedEvent>(_onAuthChanged);
  }

  void _listenToAuthChanges() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      add(AuthChangedEvent(user: user));
    });
  }

  Future<void> _onAuthChanged(
    AuthChangedEvent event,
    Emitter<CartState> emit,
  ) async {
    if (event.user != null) {
      // Usuario autenticado - cargar carrito
      add(LoadCartEvent());
    } else {
      // Usuario no autenticado - limpiar estado
      emit(CartLoaded([]));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoading) {
      try {
        emit(CartLoading());
        await cartRepository.addToCart(
          product: event.product,
          quantity: event.quantity,
        );
        final items = await cartRepository.getCartItems();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError('Error al agregar al carrito: ${e.toString()}'));
        // Re-emitir el estado anterior después del error
        if (state is CartLoaded) {
          emit(state); // Mantener los items actuales en caso de error
        }
      }
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartLoading());
      await cartRepository.removeFromCart(
        event.cartItemId,
      ); // Usar el nuevo nombre
      final items = await cartRepository.getCartItems();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Error al remover del carrito: ${e.toString()}'));
      if (state is CartLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateCartItemQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartLoading());
      await cartRepository.updateQuantity(
        cartItemId: event.cartItemId, // Usar el nuevo nombre
        newQuantity: event.newQuantity,
      );
      final items = await cartRepository.getCartItems();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Error al actualizar cantidad: ${e.toString()}'));
      if (state is CartLoaded) {
        emit(state);
      }
    }
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final items = await cartRepository.getCartItems();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Error al cargar el carrito: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartLoading());
      await cartRepository.clearCart();
      emit(CartLoaded([]));
    } catch (e) {
      emit(CartError('Error al vaciar el carrito: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
