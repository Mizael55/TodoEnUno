import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String imageUrl; 
  final DateTime createdAt;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Product.createNew({
    required String name,
    required double price,
    required String description,
    required String category,
    required String imageUrl,
  }) {
    return Product(
      name: name,
      price: price,
      description: description,
      category: category,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt, // Enviamos DateTime directamente (Firestore lo convertirá a Timestamp)
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] as num).toDouble(),
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate() 
          : DateTime.parse(map['createdAt']),
    );
  }
}