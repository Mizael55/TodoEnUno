import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/models/models.dart';

class CartRepository {
  final FirebaseFirestore _firestore;
  late final String userId; // Aquí usaremos el uid del UserModel

  CartRepository({required this.userId, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Referencia al carrito del usuario
  CollectionReference get _cartRef => 
      _firestore.collection('users').doc(userId).collection('cart');

  /// Agrega un producto al carrito o incrementa su cantidad si ya existe
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      // Verificar si el producto ya está en el carrito
      final query = await _cartRef
          .where('product.id', isEqualTo: product.id)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        // Actualizar cantidad si ya existe
        await _cartRef.doc(query.docs.first.id).update({
          'quantity': FieldValue.increment(quantity),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Agregar nuevo item al carrito con los datos completos del producto
        await _cartRef.add({
          'product': product.toMap(),
          'quantity': quantity,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Error al agregar al carrito: ${e.toString()}');
    }
  }

  /// Elimina un producto del carrito
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _cartRef.doc(cartItemId).delete();
    } catch (e) {
      throw Exception('Error al eliminar del carrito: ${e.toString()}');
    }
  }

  /// Actualiza la cantidad de un producto en el carrito
  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(cartItemId);
        return;
      }

      await _cartRef.doc(cartItemId).update({
        'quantity': newQuantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al actualizar cantidad: ${e.toString()}');
    }
  }

  /// Obtiene todos los items del carrito
  Future<List<CartItem>> getCartItems() async {
    try {
      final snapshot = await _cartRef.get();
      return _mapSnapshotToCartItems(snapshot);
    } catch (e) {
      throw Exception('Error al obtener carrito: ${e.toString()}');
    }
  }

  /// Stream de cambios en el carrito
  Stream<List<CartItem>> streamCartItems() {
    return _cartRef
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) => _mapSnapshotToCartItems(snapshot));
  }

  /// Mapea los documentos de Firestore a objetos CartItem
  Future<List<CartItem>> _mapSnapshotToCartItems(QuerySnapshot snapshot) async {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return CartItem(
        id: doc.id,
        product: Product.fromMap(data['product'], data['product']['id']),
        quantity: data['quantity'] ?? 1,
        createdAt: data['createdAt']?.toDate(),
      );
    }).toList();
  }

  /// Limpia todo el carrito
  Future<void> clearCart() async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _cartRef.get();
      
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Error al vaciar el carrito: ${e.toString()}');
    }
  }
}