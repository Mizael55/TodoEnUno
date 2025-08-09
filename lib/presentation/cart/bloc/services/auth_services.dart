// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  static Stream<String?> get authStateChanges => 
      FirebaseAuth.instance.authStateChanges().map((user) => user?.uid);
  
  // estos son lo datos en la db 
//   createdAt
// "2025-08-06T01:38:42.884884"
// email
// "m@klk.com"
// fullName
// "Mizael Soler"
// uid
// "Abh9hWv4qeWJwLuk126KZbqK2622"
// userType
// "seller"
// lo que quiero es obtener el type del usuario actual
  static User? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user; // Aquí puedes retornar un objeto User con los datos que necesites
    }
    return null; // Si no hay usuario autenticado, retorna null
  }
}