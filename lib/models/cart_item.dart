import 'models.dart';

class CartItem {
  final String id; // ID del documento en Firestore
  final Product product;
  int quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.createdAt,
    this.updatedAt,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CartItem copyWith({
    int? quantity,
  }) {
    return CartItem(
      id: id,
      product: product,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  }