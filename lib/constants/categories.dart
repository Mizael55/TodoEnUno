import 'package:flutter/material.dart';

class ProductCategory {
  final String value;
  final String label;
  final IconData icon;

  const ProductCategory({
    required this.value,
    required this.label,
    required this.icon,
  });
}

const List<ProductCategory> productCategories = [
  ProductCategory(
    value: 'electronics',
    label: 'Electrónica',
    icon: Icons.electrical_services_rounded,
  ),
  ProductCategory(
    value: 'clothing',
    label: 'Ropa',
    icon: Icons.checkroom_rounded,
  ),
  ProductCategory(value: 'home', label: 'Hogar', icon: Icons.home_rounded),
  ProductCategory(
    value: 'sports',
    label: 'Deportes',
    icon: Icons.sports_soccer_rounded,
  ),
  ProductCategory(value: 'toys', label: 'Juguetes', icon: Icons.toys_rounded),
  ProductCategory(
    value: 'food',
    label: 'Alimentos',
    icon: Icons.fastfood_rounded,
  ),
  ProductCategory(
    value: 'books',
    label: 'Libros',
    icon: Icons.menu_book_rounded,
  ),
];
