// lib/services/firebase_storage_service.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProductImage(File imageFile) async {
    try {
      // Genera un nombre único para la imagen
      final fileName = 'products/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Sube el archivo
      final uploadTask = await _storage.ref(fileName).putFile(imageFile);
      
      // Obtiene la URL de descarga
      final imageUrl = await uploadTask.ref.getDownloadURL();
      
      return imageUrl;
    } catch (e) {
      throw Exception('Error al subir imagen: ${e.toString()}');
    }
  }
}