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
    value: 'electronica',
    label: 'Electrónica',
    icon: Icons.electrical_services_rounded,
  ),
  ProductCategory(value: 'ropa', label: 'Ropa', icon: Icons.checkroom_rounded),
  ProductCategory(value: 'hogar', label: 'Hogar', icon: Icons.home_rounded),
  ProductCategory(
    value: 'deportes',
    label: 'Deportes',
    icon: Icons.sports_soccer_rounded,
  ),
  ProductCategory(
    value: 'jueguetes',
    label: 'Juguetes',
    icon: Icons.toys_rounded,
  ),
  ProductCategory(
    value: 'alimentos',
    label: 'Alimentos',
    icon: Icons.fastfood_rounded,
  ),
  ProductCategory(
    value: 'libros',
    label: 'Libros',
    icon: Icons.menu_book_rounded,
  ),
  ProductCategory(
    value: 'salud',
    label: 'Salud',
    icon: Icons.health_and_safety_rounded,
  ),
  ProductCategory(value: 'belleza', label: 'Belleza', icon: Icons.face_rounded),
  ProductCategory(
    value: 'automotriz',
    label: 'Automotriz',
    icon: Icons.directions_car_rounded,
  ),
  ProductCategory(
    value: 'mascotas',
    label: 'Mascotas',
    icon: Icons.pets_rounded,
  ),
  ProductCategory(
    value: 'jardineria',
    label: 'Jardinería',
    icon: Icons.grass_rounded,
  ),
];
