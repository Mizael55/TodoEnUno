// auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  static Stream<String?> get authStateChanges => 
      FirebaseAuth.instance.authStateChanges().map((user) => user?.uid);
}