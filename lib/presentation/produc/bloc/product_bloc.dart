// lib/bloc/product/product_bloc.dart
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:store/presentation/produc/bloc/services/firebase_storage_service.dart';
import '../../../models/models.dart';
import 'repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  final FirebaseStorageService _storageService;

  ProductBloc({
    required ProductRepository productRepository,
    required FirebaseStorageService storageService,
  })  : _productRepository = productRepository,
        _storageService = storageService,
        super(ProductInitial()) {
    on<CreateProductWithImage>(_onCreateProductWithImage);
  }

  Future<void> _onCreateProductWithImage(
    CreateProductWithImage event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      // 1. Subir imagen a Firebase Storage
      final imageUrl = await _storageService.uploadProductImage(event.imageFile);

      // 2. Crear objeto Product con la URL de la imagen
      final product = Product.createNew(
        name: event.name,
        price: event.price,
        description: event.description,
        category: event.category,
        imageUrl: imageUrl,
      );

      // 3. Guardar en Firestore
      await _productRepository.createProduct(product);

      emit(ProductSuccess());
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }
}