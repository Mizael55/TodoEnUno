import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../models/models.dart';

class CartRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CartRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Referencia a la colección del carrito para el usuario actual
  CollectionReference<Map<String, dynamic>> get _cartRef {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  /// Agrega un producto al carrito
  Future<void> addToCart({required Product product, int quantity = 1}) async {
    try {
      // Verificar autenticación primero
      if (_auth.currentUser == null) {
        throw Exception('Debes iniciar sesión para agregar al carrito');
      }

      final existingItem = await _cartRef
          .where('product.id', isEqualTo: product.id)
          .limit(1)
          .get();

      if (existingItem.docs.isNotEmpty) {
        await _cartRef.doc(existingItem.docs.first.id).update({
          'quantity': FieldValue.increment(quantity),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _cartRef.add({
          'product': product.toMap(),
          'quantity': quantity,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Error al agregar al carrito: $e');
    }
  }

  /// Remueve un producto del carrito
  Future<void> removeFromCart(String cartItemId) async {
    print("🔥 Entrando a removeFromCart para ID: $cartItemId");

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        print("⚠️ Usuario no autenticado");
        throw Exception('Usuario no autenticado');
      }

      print("📌 Referencia a documento: users/$userId/cart/$cartItemId");
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();

      print("✅ Documento eliminado exitosamente");
    } catch (e) {
      print("💥 Error en removeFromCart: $e");
      rethrow;
    }
  }

  /// Actualiza la cantidad de un producto en el carrito
  Future<void> updateQuantity({
    required String cartItemId,
    required int newQuantity,
  }) async {
    try {
      // Ahora usamos directamente el ID del documento del carrito
      await _cartRef.doc(cartItemId).update({
        'quantity': newQuantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al actualizar cantidad: $e');
    }
  }

  /// Obtiene todos los items del carrito
  Future<List<CartItem>> getCartItems() async {
    try {
      final snapshot = await _cartRef.get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CartItem(
          id: doc.id,
          product: Product.fromMap(
            data['product']['id'] ?? '',
            data['product'],
          ),
          quantity: data['quantity'] ?? 1,
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener el carrito: $e');
    }
  }

  /// Vacía completamente el carrito
  Future<void> clearCart() async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _cartRef.get();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Error al vaciar el carrito: $e');
    }
  }
}
