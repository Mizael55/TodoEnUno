// lib/repositories/product_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/models.dart';

/// Repositorio para manejar operaciones CRUD de productos con Firestore
class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Crea un nuevo producto en Firestore
  /// Devuelve el ID del documento creado
  Future<String> createProduct(Product product) async {
    try {
      // Convierte el producto a Map
      final productData = product.toMap();

      // Agrega el documento a la colección 'products'
      final docRef = await _firestore.collection('products').add(productData);

      return docRef.id; // Retorna el ID generado por Firestore
    } catch (e) {
      throw Exception('Error al crear producto: ${e.toString()}');
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final snapshot =
          await _firestore
              .collection('products')
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar productos: ${e.toString()}');
    }
  }

  Stream<List<Product>> streamProducts() {
    return _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Product.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }
}
