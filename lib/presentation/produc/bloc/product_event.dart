part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class CreateProductWithImage extends ProductEvent {
  final String name;
  final double price;
  final String description;
  final String category;
  final File imageFile;

  const CreateProductWithImage({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageFile,
  });

  @override
  List<Object> get props => [name, price, description, category, imageFile];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class ListenProducts extends ProductEvent {
  const ListenProducts();
}

class DeleteProduct extends ProductEvent {
  final String productId;

  const DeleteProduct(this.productId);

  @override
  List<Object> get props => [productId];
}