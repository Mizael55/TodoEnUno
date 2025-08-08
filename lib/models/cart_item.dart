import 'models.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;
  final DateTime? createdAt;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.createdAt,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'createdAt': createdAt,
    };
  }

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      product: product,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt,
    );
  }
}
